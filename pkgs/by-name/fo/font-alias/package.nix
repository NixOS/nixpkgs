{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  gitUpdater,
  autoreconfHook,
  font-util,
  util-macros,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-alias";
  version = "1.0.6";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "alias";
    tag = "font-alias-${finalAttrs.version}";
    hash = "sha256-WGCC4OTerSRf+2sGNqggSBzVVv7gcuP6s3QQHBLahdM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    font-util
    util-macros
  ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "font-alias-";
    };
  };

  meta = {
    description = "Common aliases for Xorg fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/alias";
    license = with lib.licenses; [
      cronyx
      mit
    ];
    maintainers = with lib.maintainers; [ qweered ];
  };
})
