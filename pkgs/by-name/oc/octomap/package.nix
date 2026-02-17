{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "octomap";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "OctoMap";
    repo = "octomap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QxQHxxFciR6cvB/b8i0mr1hqGxOXhXmB4zgdsD977Mw=";
  };

  sourceRoot = "${finalAttrs.src.name}/octomap";

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=deprecated-declarations"
  ];

  meta = {
    description = "Probabilistic, flexible, and compact 3D mapping library for robotic systems";
    homepage = "https://octomap.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.unix;
  };
})
