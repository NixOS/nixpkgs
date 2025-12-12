{
  testers,
  fetchurl,
  jq,
  moreutils,
  ...
}:
{
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
