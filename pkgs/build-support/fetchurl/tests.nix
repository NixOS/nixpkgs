{
  testers,
  fetchurl,
  jq,
  moreutils,
  writeText,
  runCommand,
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

  sslCertFileOverride =
    let
      contents = ''
        example!
      '';
      file = writeText "example.txt" contents;

      src = testers.invalidateFetcherByDrvHash fetchurl {
        url = "file://${file}";
        sha256 = builtins.hashString "sha256" contents;
      };

      srcWithOverride = src.overrideAttrs {
        outputHash = "";
      };
    in
    runCommand "test-fetchurl-override" { } ''
      touch $out
      # Make sure TLS verification is disabled in src, as it has a valid hash
      if [ "${src.SSL_CERT_FILE}" != "/no-cert-file.crt" ]; then
        echo "Unexpected value for src.SSL_CERT_FILE: ${src.SSL_CERT_FILE}" >&2
        exit 2
      fi
      # Make sure TLS verification is enabled in srcWithOverride, as it has an empty hash
      if [ "${src.SSL_CERT_FILE}" == "${srcWithOverride.SSL_CERT_FILE}" ]; then
        echo "Unexpected value for srcWithOverride.SSL_CERT_FILE: ${srcWithOverride.SSL_CERT_FILE}" >&2
        exit 1
      fi
    '';
}
