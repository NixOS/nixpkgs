{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reactphysics3d";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "DanielChappuis";
    repo = "reactphysics3d";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZwV3mh/onlHPHeT6tky2CpawLZxEikY6hq4FVn6i5hI=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Open source C++ physics engine library";
    homepage = "https://www.reactphysics3d.com";
    changelog = "https://github.com/DanielChappuis/reactphysics3d/releases/tag/${finalAttrs.src.rev}";
    maintainers = with maintainers; [ rexxDigital ];
    license = licenses.zlib;
    platforms = platforms.all;
  };
})
