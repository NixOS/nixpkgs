{ stdenv
, buildBazelPackage
, fetchFromGitHub
, cacert
, git
, glibcLocales
, go
, iproute
, iptables
, makeWrapper
, procps
, python3
}:

let
  preBuild = ''
    patchShebangs .

    # Tell rules_go to use the Go binary found in the PATH
    sed -E -i \
      -e 's|go_version\s*=\s*"[^"]+",|go_version = "host",|g' \
      WORKSPACE

    # The gazelle Go tooling needs CA certs
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"

    # If we don't reset our GOPATH, the rules_go stdlib builder tries to
    # install something into it. Ideally that wouldn't happen, but for now we
    # can also get around it by unsetting GOPATH entirely, since rules_go
    # doesn't need it.
    export GOPATH=
  '';

in buildBazelPackage rec {
  name = "gvisor-${version}";
  version = "2019-11-14";

  src = fetchFromGitHub {
    owner = "google";
    repo  = "gvisor";
    rev   = "release-20191114.0";
    sha256 = "0kyixjjlws9iz2r2srgpdd4rrq94vpxkmh2rmmzxd9mcqy2i9bg1";
  };

  nativeBuildInputs = [ git glibcLocales go makeWrapper python3 ];

  bazelTarget = "//runsc:runsc";

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

    sha256 = "1bn7nhv5pag8fdm8l8nvgg3fzvhpy2yv9yl2slrb16lckxzha3v6";
  };

  buildAttrs = {
    inherit preBuild;

    installPhase = ''
      install -Dm755 bazel-bin/runsc/*_pure_stripped/runsc $out/bin/runsc

      # Needed for the 'runsc do' subcomand
      wrapProgram $out/bin/runsc \
        --prefix PATH : ${stdenv.lib.makeBinPath [ iproute iptables procps ]}
    '';
  };

  meta = with stdenv.lib; {
    description = "Container Runtime Sandbox";
    homepage = https://github.com/google/gvisor;
    license = licenses.asl20;
    maintainers = with maintainers; [ andrew-d ];
    platforms = [ "x86_64-linux" ];
  };
}
