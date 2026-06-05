{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "duat";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "AhoyISki";
    repo = "duat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q8HeUN6JeT0OktOrmX3/ohUxCUvbEnlYKukFmtuuA44=";
  };

  cargoHash = "sha256-Wv2EdOGGsDqdXLvqyZ1sExqTlF+hHYEJu+RON7Ge398=";

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
