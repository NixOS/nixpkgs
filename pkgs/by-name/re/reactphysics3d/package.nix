{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "reactphysics3d";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "DanielChappuis";
    repo = "reactphysics3d";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LWBnrqDFhpzN/XUEGniZeViDq3R1MtmuU5CMCQ59VOY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An open source C++ physics engine library";
    homepage = "https://www.reactphysics3d.com";
    maintainers = with maintainers; [ rexxDigital ];
    license = licenses.zlib;
    platforms = platforms.all;
  };
})
