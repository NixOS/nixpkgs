{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "feroxbuster";
<<<<<<< HEAD
  version = "2.13.1";
=======
  version = "2.13.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "epi052";
    repo = "feroxbuster";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-x0oNgDEuRIHDUUSAiIgcjmm6NadyBFuvz/hOcqquM3g=";
  };

  cargoHash = "sha256-kWRODW1BsnifEqGZj8jK5tUK/5zK1AIRSq3JSo6YmkI=";

  env.OPENSSL_NO_VENDOR = true;
=======
    hash = "sha256-4YjZhBG+4Oo8mfEslNCNl0KFiqWsoreo9cPGYUoDJlk=";
  };

  cargoHash = "sha256-D5wiNzB83AWAy2N2ykzu6PNJPZ2PT/qtLPeiQzT2OxE=";

  OPENSSL_NO_VENDOR = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];

  buildInputs = [ openssl ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Recursive content discovery tool";
    homepage = "https://github.com/epi052/feroxbuster";
    changelog = "https://github.com/epi052/feroxbuster/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.unix;
=======
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Recursive content discovery tool";
    homepage = "https://github.com/epi052/feroxbuster";
    changelog = "https://github.com/epi052/feroxbuster/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "feroxbuster";
  };
}
