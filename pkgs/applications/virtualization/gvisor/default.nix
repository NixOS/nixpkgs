{ stdenv
, buildBazelPackage
, ensureNewerSourcesForZipFilesHook
, fetchFromGitHub
, writeScriptBin
, cacert
, git
, glibcLocales
, go
, iproute
, iptables
, makeWrapper
, procps
, python3
, unzip
, zip
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

  # Python wheels are .zip files, but when they're created they differ
  # depending on filesystem iteration order and are thus non-reproducible.
  # However, we can make them reproducible by unzipping them, listing all
  # files, and then re-creating the wheel file with a sorted list.
  makeReproducibleWheel = writeScriptBin "make-reproducible-wheel" ''
    #!${stdenv.shell}

    set -euo pipefail

    main() {
      local input="$1"; shift
      echo "making wheel reproducible: $input" >&2

      local tmpdir="/tmp/wheel"
      mkdir -p "$tmpdir"
      trap "rm -rf $tmpdir" EXIT

      cd "$tmpdir"
      ${unzip}/bin/unzip -qq "$input"

      local files="$(find . -type f | LC_ALL=C sort)"
      ${zip}/bin/zip -q -r -o -X /tmp/replacement.whl $files 2>/dev/null
      cd /tmp

      mv /tmp/replacement.whl "$input"
    }

    main "$@"
  '';

in buildBazelPackage rec {
  name = "gvisor-${version}";
  version = "2020-03-27";

  src = fetchFromGitHub {
    owner = "google";
    repo  = "gvisor";
    rev   = "f6e4daa67ad5f07ac1bcff33476b4d13f49a69bc";
    sha256 = "14r5325cf4cl04dqk9c03gpj21jjr8y0byar628wn8l4h6q9kgrp";
  };

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook
    makeReproducibleWheel
    git
    glibcLocales
    go
    makeWrapper
    python3
  ];

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

      # Make all Python wheels reproducible
      find "$bazelOut/external/pydeps" -name '*.whl' -exec make-reproducible-wheel {} \;
    '';

    sha256 = "1rhnc3sicfd8kyrz6sys7m2fq6mcqpci32d262xxyvh36g6hdnls";
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
