{ lib
, buildBazelPackage
, bazel_5
, fetchFromGitHub
, fetchzip
, callPackage
, bash
, cacert
, git
, glibcLocales
, go
, iproute2
, iptables
, makeWrapper
, procps
, protobuf
, python3
}:

let
  preBuild = ''
    patchShebangs .

    substituteInPlace tools/defs.bzl \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"

    # The gazelle Go tooling needs CA certs
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"

    # If we don't reset our GOPATH, the rules_go stdlib builder tries to
    # install something into it. Ideally that wouldn't happen, but for now we
    # can also get around it by unsetting GOPATH entirely, since rules_go
    # doesn't need it.
    export GOPATH=
  '';

  # Patch the protoc alias so that it always builds from source.
  rulesProto = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "rules_proto";
    rev = "f7a30f6f80006b591fa7c437fe5a951eb10bcbcf";
    sha256 = "sha256-aOO5NS9LGr3ms1YqXonQzhKeLBoVVzoGPHNqkCPgbIE=";
    extraPostFetch = ''
      sed -i 's|name = "protoc"|name = "_protoc_original"|' $out/proto/private/BUILD.release
      cat <<EOF >>$out/proto/private/BUILD.release
      alias(name = "protoc", actual = "@com_github_protocolbuffers_protobuf//:protoc", visibility = ["//visibility:public"])
      EOF
    '';
  };

  buildBazelPackage' = buildBazelPackage.override { bazel = bazel_5; };

in buildBazelPackage' rec {
  pname = "gvisor";
  version = "20220516.0";

  src = fetchFromGitHub {
    owner = "google";
    repo  = "gvisor";
    rev   = "release-${version}";
    sha256 = "sha256-ZG78fcoCpxQ9HbF+sNvywLq3nMZPLYTcBWdSCEDmHwM=";
  };

  # Currently still fails at
  # ERROR: /build/source/pkg/metric/BUILD:23:14: GoCompilePkg pkg/metric/metric_go_proto.a failed: (Exit 1): builder failed: error executing command bazel-out/k8-opt-exec-2B5CBBC6-ST-3ea255117c10/bin/external/go_sdk/builder compilepkg -sdk external/go_sdk -installsuffix linux_amd64 -src ... (remaining 51 arguments skipped)

  patches = [
    ./build-rule.patch
  ];

  nativeBuildInputs = [ git glibcLocales go makeWrapper python3 ];

  bazelTarget = "//runsc:runsc";
  bazelFlags = [
    "--override_repository=rules_proto=${rulesProto}"
  ];

  # gvisor uses the Starlark implementation of rules_cc, not the built-in one,
  # so we shouldn't delete it from our dependencies.
  removeRulesCC = false;

  fetchAttrs = {
    inherit preBuild;

    preInstall = ''
      # Remove the go_sdk (it's just a copy of the go derivation) and all
      # references to it from the marker files. Bazel does not need to download
      # this sdk because we have patched the WORKSPACE file to point to the one
      # currently present in PATH. Without removing the go_sdk from the marker
      # file, the hash of it will change anytime the Go derivation changes and
      # that would lead to impurities in the marker files which would result in
      # a different sha256 for the fetch phase.
      rm -rf $bazelOut/external/{go_sdk,\@go_sdk.marker}

      # Remove the gazelle tools, they contain go binaries that are built
      # non-deterministically. As long as the gazelle version matches the tools
      # should be equivalent.
      rm -rf $bazelOut/external/{bazel_gazelle_go_repository_tools,\@bazel_gazelle_go_repository_tools.marker}

      # Remove the gazelle repository cache
      chmod -R +w $bazelOut/external/bazel_gazelle_go_repository_cache
      rm -rf $bazelOut/external/{bazel_gazelle_go_repository_cache,\@bazel_gazelle_go_repository_cache.marker}

      # Remove log file(s)
      rm -f "$bazelOut"/java.log "$bazelOut"/java.log.*
    '';

    sha256 = "sha256-44tbIb2stPgtXkMgRGyM4t0LZcAoi45xR+7MRWa0NKI=";
  };

  buildAttrs = {
    inherit preBuild;

    installPhase = ''
      install -Dm755 bazel-out/*/bin/runsc/runsc_/runsc $out/bin/runsc

      # Needed for the 'runsc do' subcomand
      wrapProgram $out/bin/runsc \
        --prefix PATH : ${lib.makeBinPath [ iproute2 iptables procps ]}
    '';
  };

  meta = with lib; {
    description = "Container Runtime Sandbox";
    homepage = "https://github.com/google/gvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ andrew-d ];
    platforms = [ "x86_64-linux" ];
  };
}
