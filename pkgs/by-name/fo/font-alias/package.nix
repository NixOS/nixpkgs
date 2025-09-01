{
  lib,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  autoreconfHook,
  font-util,
  util-macros,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-alias";
  version = "1.0.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "alias";
    tag = "font-alias-${finalAttrs.version}";
    hash = "sha256-qglRNSt/PgFprpsvOVCeLMA+YagJw8DZMAfFdZ0m0/s=";
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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
