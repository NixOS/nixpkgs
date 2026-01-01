{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "octomap";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "OctoMap";
    repo = "octomap";
    rev = "v${version}";
    hash = "sha256-QxQHxxFciR6cvB/b8i0mr1hqGxOXhXmB4zgdsD977Mw=";
  };

  sourceRoot = "${src.name}/octomap";

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=deprecated-declarations"
  ];

<<<<<<< HEAD
  meta = {
    description = "Probabilistic, flexible, and compact 3D mapping library for robotic systems";
    homepage = "https://octomap.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Probabilistic, flexible, and compact 3D mapping library for robotic systems";
    homepage = "https://octomap.github.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
