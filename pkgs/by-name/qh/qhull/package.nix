{ lib, stdenv, fetchFromGitHub, cmake, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "qhull";
  version = "2020.2";

  src = fetchFromGitHub {
    owner = "qhull";
    repo = "qhull";
    rev = version;
    sha256 = "sha256-djUO3qzY8ch29AuhY3Bn1ajxWZ4/W70icWVrxWRAxRc=";
  };

  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  meta = with lib; {
    homepage = "http://www.qhull.org/";
    description = "Compute the convex hull, Delaunay triangulation, Voronoi diagram and more";
    license = licenses.qhull;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
