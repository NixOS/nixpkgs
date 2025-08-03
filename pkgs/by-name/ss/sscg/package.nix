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
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "sgallagher";
    repo = "sscg";
    tag = "sscg-${finalAttrs.version}";
    hash = "sha256-vHZuBjFs7sGIMGFWyqaW0SzzDDsrszlLmLREJtjLH2g=";
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
  versionCheckProgramArg = "--version";
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
