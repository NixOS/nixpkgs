{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  testers,
  validatePkgConfig,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libsfdo";
  version = "0.1.4";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "vyivel";
    repo = "libsfdo";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-xT1pKKElwKSd43XTKuBY+9rogquV1IAAYgWV5lEpAHk=";
  };

  strictDeps = true;
  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    validatePkgConfig
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    description = "Collection of libraries which implement some of the freedesktop.org specifications";
    homepage = "https://gitlab.freedesktop.org/vyivel/libsfdo";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.zi3m5f ];
    pkgConfigModules = [
      "libsfdo-basedir"
      "libsfdo-desktop-file"
      "libsfdo-desktop"
      "libsfdo-icon"
    ];
    platforms = lib.platforms.all;
  };
})
