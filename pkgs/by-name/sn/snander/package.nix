{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snander";
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "Droid-Max";
    repo = "SNANDer";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-YsNWjlbUTAURD6eOt8ZVDBGMZT4w0hGFO6N42CdX2XA=";
  };

  buildInputs = [ libusb1 ];

  makeFlags = [
    "-C"
    "src"
  ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-h";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      ''^v\.(\d+\.\d+\.\d+)$''
    ];
  };

  meta = {
    description = "Serial Nor/nAND/Eeprom programmeR (based on CH341A)";
    homepage = "https://github.com/Droid-Max/SNANDer";
    changelog = "https://github.com/Droid-Max/SNANDer/releases/tag/v.${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bmwagner18 ];
    mainProgram = "snander";
    platforms = lib.platforms.linux;
  };
})
