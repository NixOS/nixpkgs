{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  versionCheckHook,
  meson,
  pkg-config,
  openssl,
  ding-libs,
  talloc,
  popt,
  help2man,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sscg";
<<<<<<< HEAD
  version = "4.0.3";
=======
  version = "4.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sgallagher";
    repo = "sscg";
    tag = "sscg-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-0t3ntUxfh1jFukWGwmdbt0axFfUiH1QEq6wFrGoI7Jk=";
=======
    hash = "sha256-SWsKYvUDnPuDZfoQGFhSDeYbeaWN0M8GuOfuAMn90gE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    openssl
    ding-libs
    talloc
    popt
    help2man
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = gitUpdater { rev-prefix = "sscg-"; };

  meta = {
    description = "Simple Signed Certificate Generator";
    homepage = "https://github.com/sgallagher/sscg";
    changelog = "https://github.com/sgallagher/sscg/blob/sscg-${finalAttrs.version}";
    license = [ lib.licenses.gpl3 ];
    maintainers = [ lib.maintainers.lucasew ];
    mainProgram = "sscg";
  };
})
