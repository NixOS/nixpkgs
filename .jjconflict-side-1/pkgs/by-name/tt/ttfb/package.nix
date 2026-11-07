{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ttfb";
  version = "2.0.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-9iuDGnUB0Oi2yZQ8zDjLSXGUbLfRP+glkJLxrDgPnpQ=";
  };

  cargoHash = "sha256-8CIXk7OvSRmtWP/P5teJLSW9tBPHIyhW2A/NjCC6lTo=";

  # The bin feature activates all dependencies of the binary. Otherwise,
  # only the library is build.
  buildFeatures = [ "bin" ];

  meta = {
    description = "CLI-Tool to measure the TTFB (time to first byte) of HTTP(S) requests";
    mainProgram = "ttfb";
    longDescription = ''
      ttfb measure the TTFB (time to first byte) of HTTP(S) requests. This includes data
      of intermediate steps, such as the relative and absolute timings of DNS lookup, TCP
      connect, and TLS handshake.
    '';
    homepage = "https://github.com/phip1611/ttfb";
    changelog = "https://github.com/phip1611/ttfb/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phip1611 ];
  };
})
