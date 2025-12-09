{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libGL,
  SDL2,
  libGLU,
  catch2,
}:

stdenv.mkDerivation {
  pname = "recastai";
  # use latest revision for CMake v4
  # OpenMW use e75adf86f91eb3082220085e42dda62679f9a3ea
  version = "unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "recastnavigation";
    repo = "recastnavigation";
    rev = "40ec6fcd6c0263a3d7798452aee531066072d15d";
    hash = "sha256-4flJMJsuCecpHDtgAsnDU7WoAtUg/XJfRXx096Zw6bE=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Expects SDL2.framework in specific location, which we don't have
    # Change where SDL2 headers are searched for to match what we do have
    substituteInPlace RecastDemo/CMakeLists.txt \
      --replace 'include_directories(''${SDL2_LIBRARY}/Headers)' 'include_directories(${lib.getInclude SDL2}/include/SDL2)'
  '';

  doCheck = true;

  nativeBuildInputs = [ cmake ];
  checkInputs = [ catch2 ];

  buildInputs = [
    libGL
    SDL2
    libGLU
  ];

  meta = {
    homepage = "https://github.com/recastnavigation/recastnavigation";
    description = "Navigation-mesh Toolset for Games";
    mainProgram = "RecastDemo";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ marius851000 ];
    platforms = lib.platforms.all;
  };
}
