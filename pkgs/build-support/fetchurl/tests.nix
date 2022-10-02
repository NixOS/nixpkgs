{ invalidateFetcherByDrvHash, fetchurl, jq, moreutils, ... }: {
  # Tests that we can send custom headers with spaces in them
  header =
    let headerValue = "Test '\" <- These are some quotes";
    in invalidateFetcherByDrvHash fetchurl {
      url = "https://httpbin.org/headers";
      sha256 = builtins.hashString "sha256" (headerValue + "\n");
      curlOptsList = [ "-H" "Hello: ${headerValue}" ];
      postFetch = ''
        ${jq}/bin/jq -r '.headers.Hello' $out | ${moreutils}/bin/sponge $out
      '';
    };
}
