{
  lib,
  testers,
  fetchurl,
  writeShellScriptBin,
  jq,
  moreutils,
  emptyFile,
  ...
}:
let
  testFlagAppending =
    args:
    testers.invalidateFetcherByDrvHash
      (fetchurl.override (previousArgs: {
        curl = (
          writeShellScriptBin "curl" ''
            set -eu -o pipefail
            hasFoo=
            hasBar=
            echo "curl-mock-expecting-flags: get flags: $*" >&2
            for arg; do
              case "$arg" in
              -V|--version)
                ${lib.getExe previousArgs.curl} "$arg"
                exit "$?"
                ;;
              --foo)
                echo "curl-mock-expecting-flags: \`--foo' found in the argument list passed to \`curl'." >&2
                hasFoo=1
                ;;
              --bar)
                echo "curl-mock-expecting-flags: \`--bar' found in the argument list passed to \`curl'." >&2
                hasBar=1
                ;;
              esac
            done
            if [[ -z "$hasFoo" ]]; then
              echo "ERROR: curl-mock-expecting-flags: \`--foo' missing in the argument list passed to \`curl'." >&2
            fi
            if [[ -z "$hasBar" ]]; then
              echo "ERROR: curl-mock-expecting-flags: \`--bar' missing in the argument list passed to \`curl'." >&2
            fi
            if [[ -n "$hasFoo" ]] && [[ -n "$hasBar" ]]; then
              touch $out
            else
              exit 1
            fi
          ''
        );
      }))
      (
        {
          url = "https://www.example.com/source";
          hash = emptyFile.outputHash;
          recursiveHash = true; # aligned with emptyFile
        }
        // args
      );
in
{
  flag-appending-curlOpts = testFlagAppending {
    name = "test-fetchurl-flag-appending-curlOpts";
    curlOpts = "--foo --bar";
  };

  flag-appending-curlOptsList = testFlagAppending {
    name = "test-fetchurl-flag-appending-curlOptsList";
    curlOptsList = [
      "--foo"
      "--bar"
    ];
  };

  flag-appending-netrcPhase-curlOpts = testFlagAppending {
    name = "test-fetchurl-flag-appending-netrcPhase-curlOpts";
    netrcPhase = ''
      touch netrc
      curlOpts="$curlOpts --foo --bar"
    '';
  };

  # Tests that we can send custom headers with spaces in them
  header =
    let
      headerValue = "Test '\" <- These are some quotes";
    in
    testers.invalidateFetcherByDrvHash fetchurl {
      url = "https://httpbin.org/headers";
      sha256 = builtins.hashString "sha256" (headerValue + "\n");
      curlOptsList = [
        "-H"
        "Hello: ${headerValue}"
      ];
      postFetch = ''
        ${jq}/bin/jq -r '.headers.Hello' $out | ${moreutils}/bin/sponge $out
      '';
    };

  # Tests that hashedMirrors works
  hashedMirrors = testers.invalidateFetcherByDrvHash fetchurl {
    # Make sure that we can only download from hashed mirrors
    url = "http://broken";
    # A file with this hash is definitely on tarballs.nixos.org
    sha256 = "1j1y3cq6ys30m734axc0brdm2q9n2as4h32jws15r7w5fwr991km";

    # No chance
    curlOptsList = [
      "--retry"
      "0"
    ];
  };

  # Tests that downloadToTemp works with hashedMirrors
  no-skipPostFetch = testers.invalidateFetcherByDrvHash fetchurl {
    # Make sure that we can only download from hashed mirrors
    url = "http://broken";
    # A file with this hash is definitely on tarballs.nixos.org
    sha256 = "1j1y3cq6ys30m734axc0brdm2q9n2as4h32jws15r7w5fwr991km";

    # No chance
    curlOptsList = [
      "--retry"
      "0"
    ];

    downloadToTemp = true;
    # Usually postFetch is needed with downloadToTemp to populate $out from
    # $downloadedFile, but here we know that because the URL is broken, it will
    # have to fallback to fetching the previously-built derivation from
    # tarballs.nixos.org, which provides pre-built derivation outputs.
  };
}
