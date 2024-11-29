{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "clipper2";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "AngusJohnson";
    repo = "Clipper2";
    rev = "Clipper2_${version}";
    hash = "sha256-ASL9uKkXsWyIbD1qaKEL7gf/JuCqzZQZSKHwLT5dKJU=";
  };

  sourceRoot = "${src.name}/CPP";

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCLIPPER2_EXAMPLES=OFF"
    "-DCLIPPER2_TESTS=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  patches = [
    ./0001-fix-pc-paths.patch
  ];

  meta = {
    description = "Polygon Clipping and Offsetting - C++ Only";
    longDescription = ''
      The Clipper2 library performs intersection, union, difference and XOR boolean operations on both simple and
      complex polygons. It also performs polygon offsetting.
    '';
    homepage = "https://github.com/AngusJohnson/Clipper2";
    license = lib.licenses.boost;
    maintainers = [ lib.maintainers.cadkin ];
    platforms = lib.platforms.all;
  };
}
