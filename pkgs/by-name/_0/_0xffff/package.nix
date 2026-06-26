{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb-compat-0_1,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "0xFFFF";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "0xFFFF";
    tag = finalAttrs.version;
    hash = "sha256-RTpiH6OpC1hRbhLW5Em01oDQdpAZ/mfggCDLSUzOC9s=";
  };

  strictDeps = true;

  buildInputs = [ libusb-compat-0_1 ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-h";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Free Fiasco Firmware Flasher for Maemo devices";
    homepage = "https://github.com/pali/0xFFFF";
    changelog = "https://github.com/pali/0xFFFF/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "0xFFFF";
  };
})
