{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "reactphysics3d";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "DanielChappuis";
    repo = "reactphysics3d";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j57wzqAmBV/pK7PPUDXV6ciOCQVs2gX+BaGHk4kLuUI=";
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
