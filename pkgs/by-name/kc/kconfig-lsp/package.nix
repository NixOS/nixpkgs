{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kconfig-lsp";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cccheng";
    repo = "kconfig-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TfJfFu8l8XM4KDp+CpFnH+gdneKEULe/K0XM+Ua0G+c=";
  };

  cargoHash = "sha256-kEPfQa+Zv7M/KWE6NZX2HU8TWVESsusPiqVOiuoCtUM=";

  meta = {
    description = "Language server for the Kconfig configuration language used in Linux, Zephyr, U-Boot, coreboot, and other projects";
    homepage = "https://github.com/cccheng/kconfig-lsp";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "kconfig-lsp";
  };
})
