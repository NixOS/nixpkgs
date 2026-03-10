{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "duat";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "AhoyISki";
    repo = "duat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wz2WMAgTBTu2qZ8nyuedJJ2UFEwPFkU8jWPYw11R1Wg=";
  };

  cargoHash = "sha256-EtJ0u48uPXsWBBVyRP1jk+1Qmofpd3J/M42Rjrf3zTE=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern and customizable text editor, built and configured in Rust";
    homepage = "https://github.com/AhoyISki/duat";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "duat";
  };
})
