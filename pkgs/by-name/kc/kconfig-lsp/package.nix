{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kconfig-lsp";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cccheng";
    repo = "kconfig-lsp";
    rev = "0579ddd3760ccd243a828b40cfbcd496d33b7808";
    hash = "sha256-u3odBmcCXB1pCf92rWTlQwNRFHI4TUKd3OqIw+7Krq4=";
  };

  cargoHash = "sha256-VIZqGSdHW1R0gczvfKY7BX55sFteamUR36XWoTJuJwE=";

  meta = {
    description = "A language server for the Kconfig configuration language used in Linux, Zephyr, U-Boot, coreboot, and other projects.";
    homepage = "https://github.com/cccheng/kconfig-lsp";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "kconfig-lsp";
  };

})
