{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qhull";
  version = "2020.2";

  src = fetchFromGitHub {
    owner = "qhull";
    repo = "qhull";
    rev = finalAttrs.version;
    sha256 = "sha256-djUO3qzY8ch29AuhY3Bn1ajxWZ4/W70icWVrxWRAxRc=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  # Fix the build with CMake 4.
  #
  # Remove on the next version bump.
  #
  # See: <https://github.com/qhull/qhull/commit/62ccc56af071eaa478bef6ed41fd7a55d3bb2d80>
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.0)' \
        'cmake_minimum_required(VERSION 3.5...4.0)'
  '';

  meta = {
    homepage = "http://www.qhull.org/";
    description = "Compute the convex hull, Delaunay triangulation, Voronoi diagram and more";
    license = lib.licenses.qhull;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
