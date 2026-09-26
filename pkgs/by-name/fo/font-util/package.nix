{
  lib,
  stdenv,
  fetchFromGitLab,
  testers,
  gitUpdater,
  autoreconfHook,
  util-macros,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-util";
  version = "1.4.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "util";
    tag = "font-util-${finalAttrs.version}";
    hash = "sha256-tB6A5ezfHwzhL3HsWPZjX3/d53Zkm4hBFbxOnTUgNZc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    util-macros
  ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "font-util-";
      ignoredVersions = "1_0_1";
    };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "X.Org font package creation/installation utilities";
    homepage = "https://gitlab.freedesktop.org/xorg/font/util";
    license = with lib.licenses; [
      mit
      bsd2
      bsdSourceCode
      mitOpenGroup
      # there is a bit of a diff, but i think its close enough
      # it was probably just adapted a bit to fit to the repository structure
      # or its an older version that the one on spdx
      unicodeTOU
    ];
    maintainers = [ ];
    pkgConfigModules = [ "fontutil" ];
    platforms = lib.platforms.unix;
  };
})
