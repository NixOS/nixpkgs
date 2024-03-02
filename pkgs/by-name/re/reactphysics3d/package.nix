{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "reactphysics3d";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "DanielChappuis";
    repo = "reactphysics3d";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AUdsUXsygsGfS8H+AHEV1fSrrX7zGmfsaTONYUG3zqk=";
  };

  patches = [
    # Fix gcc-13 build failure:
    #   https://github.com/DanielChappuis/reactphysics3d/pull/371
    (fetchpatch {
      name ="gcc-13.patch";
      url = "https://github.com/DanielChappuis/reactphysics3d/commit/9335856664fdc3bd1073209f0b4f6eae24c35848.patch";
      hash = "sha256-pCiAHfv66tbE8+hpVvjS22jLi7I+pPofSy8w7eWEp9o=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An open source C++ physics engine library";
    homepage = "https://www.reactphysics3d.com";
    maintainers = with maintainers; [ rexxDigital ];
    license = licenses.zlib;
    platforms = platforms.all;
  };
})
