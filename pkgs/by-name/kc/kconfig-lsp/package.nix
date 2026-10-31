{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kconfig-lsp";
  version = "0.3.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cccheng";
    repo = "kconfig-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y0mQrOndA+FBc+Xx7In+jZvvmvOPsIkuODepky69iXQ=";
  };

  cargoHash = "sha256-c9ghzUnPpnAiafNWcAJJbWY2tAE1MxyRx6v7I0zA0sw=";

  meta = {
    description = "Language server for the Kconfig configuration language used in Linux, Zephyr, U-Boot, coreboot, and other projects";
    homepage = "https://github.com/cccheng/kconfig-lsp";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "kconfig-lsp";
  };
})
