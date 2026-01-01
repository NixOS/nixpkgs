{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ferron";
<<<<<<< HEAD
  version = "2.2.1";
=======
  version = "1.3.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ferronweb";
    repo = "ferron";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-+Esbsr+pqRSRd3M7mFhNl+KVcz3wO5YlZrna8mYsV80=";
  };

  # ../../ is cargoDepsCopy, and obviously does not contain monoio's README.md
  postPatch = ''
    substituteInPlace $cargoDepsCopy/monoio-0.2.4/src/lib.rs \
      --replace-fail '#![doc = include_str!("../../README.md")]' ""
  '';

  cargoHash = "sha256-/F1CqzOKscT/rOsJaY+PwZPMBDxSEoI+zN/GsH5P37k=";
=======
    hash = "sha256-bBIhLkh9UV2MJKovQaFk3cC1rYafiyxknRlKWVQ5gwY=";
  };

  cargoHash = "sha256-xsJJglSq8hpWWi0zknPL03nle99GxznPI3HON2o8zco=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast, memory-safe web server written in Rust";
    homepage = "https://github.com/ferronweb/ferron";
    changelog = "https://github.com/ferronweb/ferron/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      _0x4A6F
      GaetanLepage
    ];
    mainProgram = "ferron";
  };
})
