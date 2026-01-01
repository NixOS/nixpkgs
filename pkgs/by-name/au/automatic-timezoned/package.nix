{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "automatic-timezoned";
<<<<<<< HEAD
  version = "2.0.105";
=======
  version = "2.0.103";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = "automatic-timezoned";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    sha256 = "sha256-CMdVYk1Mn0uenhPuaSG2Ruisfps8wAug0PC/GGfesYU=";
  };

  cargoHash = "sha256-fXorWbazWWBoXjTIT1t6kWRW065pTM+u+S36X7zhoj8=";
=======
    sha256 = "sha256-VxD+aXGbJTdNAI9V3meQjF4CfhPr7lChhVAN4WnH6ac=";
  };

  cargoHash = "sha256-0AZNViP2jE6/FZdo0LaLjxBPkPqnd2kvZmVtbi5W5RI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Automatically update system timezone based on location";
    homepage = "https://github.com/maxbrunet/automatic-timezoned";
    changelog = "https://github.com/maxbrunet/automatic-timezoned/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.maxbrunet ];
    platforms = lib.platforms.linux;
    mainProgram = "automatic-timezoned";
  };
})
