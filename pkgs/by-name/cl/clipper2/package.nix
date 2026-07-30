{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clipper2";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "AngusJohnson";
    repo = "Clipper2";
    tag = "Clipper2_${finalAttrs.version}";
    hash = "sha256-Pqmrj9SDooM+VU4ObQrtaU9+GN//FsD+Brp+OsN0cPM=";
  };

  sourceRoot = "${finalAttrs.src.name}/CPP";

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCLIPPER2_EXAMPLES=OFF"
    "-DCLIPPER2_TESTS=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.updateScript = nix-update-script { };

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
})
