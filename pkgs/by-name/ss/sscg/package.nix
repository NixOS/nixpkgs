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
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "sgallagher";
    repo = "sscg";
    tag = "sscg-${finalAttrs.version}";
    hash = "sha256-lfb7sMREF3KEfUu6a2NW50F8ke7pG6ZokfBDlH1+K7o=";
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
  doInstallCheck = true;

  passthru.updateScript = gitUpdater { rev-prefix = "sscg-"; };

  meta = {
    description = "Simple Signed Certificate Generator";
    homepage = "https://github.com/sgallagher/sscg";
    changelog = "https://github.com/sgallagher/sscg/blob/sscg-${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.lucasew ];
    mainProgram = "sscg";
  };
})
