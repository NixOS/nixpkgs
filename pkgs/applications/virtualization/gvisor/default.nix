{ lib
, buildBazelPackage
, fetchFromGitHub
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

    # Tell rules_go to use the Go binary found in the PATH
    sed -E -i \
      -e 's|go_version\s*=\s*"[^"]+"|go_version = "host"|g' \
      WORKSPACE

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
    sha256 = "10bcw0ir0skk7h33lmqm38n9w4nfs24mwajnngkbs6jb5wsvkqv8";
    postFetch = ''
      sed -i 's|name = "protoc"|name = "_protoc_original"|' $out/proto/private/BUILD.release
      cat <<EOF >>$out/proto/private/BUILD.release
      alias(name = "protoc", actual = "@com_github_protocolbuffers_protobuf//:protoc", visibility = ["//visibility:public"])
      EOF
    '';
  };

in buildBazelPackage rec {
  pname = "gvisor";
  version = "20210518.0";

  src = fetchFromGitHub {
    owner = "google";
    repo  = "gvisor";
    rev   = "release-${version}";
    sha256 = "15a6mlclnyfc9mx3bjksnnf4vla0xh0rv9kxdp34la4gw3c4hksn";
  };

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

    sha256 = "13pahppm431m198v5bffrzq5iw8m79riplbfqp0afh384ln669hb";
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
    # The version we have right now does not compile with go 1.17
    # See https://github.com/NixOS/nixpkgs/pull/174003 if you want to upgrade gvisor
    broken = true;
  };
}
