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
  version = "0.1.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "vyivel";
    repo = "libsfdo";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-9jCfCIB07mmJ6aWQHvXaxYhEMNikUw/W1xrpmh6FKbo=";
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

  meta = with lib; {
    description = "Collection of libraries which implement some of the freedesktop.org specifications";
    homepage = "https://gitlab.freedesktop.org/vyivel/libsfdo";
    license = licenses.bsd2;
    maintainers = [ maintainers.zi3m5f ];
    pkgConfigModules = [
      "libsfdo-basedir"
      "libsfdo-desktop-file"
      "libsfdo-desktop"
      "libsfdo-icon"
    ];
    platforms = platforms.all;
  };
})
