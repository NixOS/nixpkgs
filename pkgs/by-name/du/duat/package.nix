{
  cargo,
  cc ? targetPackages.stdenv.cc,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  rustPlatform,
  rustc,
  targetPackages,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "duat";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "AhoyISki";
    repo = "duat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SjSJc1pHUNl4G0ROZPyc7ux+Nx7RxMd6vG7jcd6INto=";
  };

  cargoHash = "sha256-gZPr/I9/Ug+PmS1mUtwQ7JVkJ4gTYctvbtpvuOY8QUc=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/duat \
      --prefix PATH : ${
        lib.makeBinPath [
          cargo
          cc
          rustc
        ]
      }
  '';

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
