{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "alioth";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "alioth";
    tag = "v${version}";
    hash = "sha256-xFNX2cxmaw2H8D21qs6mnTMuSidmJ0xJ/b4pxdLTvow=";
  };

  # Checks use `debug_assert_eq!`
  checkType = "debug";

  useFetchCargoVendor = true;
  cargoHash = "sha256-x2Abw/RVKpPx0EWyF3w0kywtd23A+NSNaHRVZ4oB1jI=";

  separateDebugInfo = true;

  meta = with lib; {
    homepage = "https://github.com/google/alioth";
    description = "Experimental Type-2 Hypervisor in Rust implemented from scratch";
    license = licenses.asl20;
    mainProgram = "alioth";
    maintainers = with maintainers; [ astro ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
