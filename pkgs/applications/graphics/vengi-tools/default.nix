{ lib
, stdenv
, fetchFromGitHub
, writeText

, cmake
, pkg-config
, ninja
, python3
, makeWrapper

, glm
, lua5_4
, SDL2
, SDL2_mixer
, enet
, libuv
, libuuid
, wayland-protocols
, Carbon
, CoreServices
# optionals
, opencl-headers
, OpenCL

, callPackage
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "vengi-tools";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "mgerhardy";
    repo = "vengi";
    rev = "v${version}";
    sha256 = "sha256-h+R9L0BBD3NSFWUh43g4V2LBcNyqVInBeJiOLY03nRk=";
  };

  # Patch from the project's author for fixing an issue with AnimationShaders.h
  # not being included when turning off some components
  patches = [(writeText "vengi-tools-fix-build.patch" ''
    diff --git a/src/modules/voxelworldrender/CMakeLists.txt b/src/modules/voxelworldrender/CMakeLists.txt
    index aebe5f97b..903e62b37 100644
    --- a/src/modules/voxelworldrender/CMakeLists.txt
    +++ b/src/modules/voxelworldrender/CMakeLists.txt
    @@ -27,7 +27,7 @@ set(FILES
            voxel/models/plants/3.qb
            voxel/models/plants/4.qb
     )
    -engine_add_module(TARGET ''${LIB} SRCS ''${SRCS} ''${SRCS_SHADERS} FILES ''${FILES} DEPENDENCIES frontend voxelrender)
    +engine_add_module(TARGET ''${LIB} SRCS ''${SRCS} ''${SRCS_SHADERS} FILES ''${FILES} DEPENDENCIES animation frontend voxelrender)
     generate_shaders(''${LIB} world water postprocess)

     set(TEST_SRCS
  '')];

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    python3
    makeWrapper
  ];

  buildInputs = [
    glm
    lua5_4
    SDL2
    SDL2_mixer
    enet
    libuv
    libuuid
    # Only needed for the game
    #postgresql
    #libpqxx
    #mosquitto
  ] ++ lib.optional stdenv.isLinux wayland-protocols
    ++ lib.optionals stdenv.isDarwin [ Carbon CoreServices OpenCL ]
    ++ lib.optional (!stdenv.isDarwin) opencl-headers;

  cmakeFlags = [
    # Disable tests due to a problem in linking gtest:
    # ld: /build/vengi-tests-core.LDHlV1.ltrans0.ltrans.o: in function `main':
    # <artificial>:(.text.startup+0x3f): undefined reference to `testing::InitGoogleMock(int*, char**)'
    "-DUNITTESTS=OFF"
    "-DVISUALTESTS=OFF"
    # We're only interested in the generic tools
    "-DGAMES=OFF"
    "-DMAPVIEW=OFF"
    "-DAIDEBUG=OFF"
  ] ++ lib.optional stdenv.isDarwin "-DCORESERVICES_LIB=${CoreServices}";

  # Set the data directory for each executable. We cannot set it at build time
  # with the PKGDATADIR cmake variable because each executable needs a specific
  # one.
  # This is not needed on darwin, since on that platform data files are saved
  # in *.app/Contents/Resources/ too, and are picked up automatically.
  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" \
        --set CORE_PATH $out/share/$(basename "$prog")/
    done
  '';

  passthru.tests = {
    # There used to be a roundtrip test here, but it started failing on 0.0.17
    # Relevant upstream ticket:
    # https://github.com/mgerhardy/vengi/issues/113
    voxconvert-all-formats = callPackage ./test-voxconvert-all-formats.nix {};
    run-voxedit = nixosTests.vengi-tools;
  };

  meta = with lib; {
    description = "Tools from the vengi voxel engine, including a thumbnailer, a converter, and the VoxEdit voxel editor";
    longDescription = ''
      Tools from the vengi C++ voxel game engine. It includes a voxel editor
      with character animation support and loading/saving into a lot of voxel
      volume formats. There are other tools like e.g. a thumbnailer for your
      filemanager and a command line tool to convert between several voxel
      formats.
    '';
    homepage = "https://mgerhardy.github.io/vengi/";
    downloadPage = "https://github.com/mgerhardy/vengi/releases";
    license = [ licenses.mit licenses.cc-by-sa-30 ];
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # Requires SDK 10.14 https://github.com/NixOS/nixpkgs/issues/101229
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
