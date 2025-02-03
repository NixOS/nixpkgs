{ lib
, stdenv
, fetchFromGitHub

, cmake
, pkg-config
, ninja
, python3
, makeWrapper

, backward-cpp
, curl
, enet
, freetype
, glm
, gtest
, libbfd
, libdwarf
, libjpeg
, libuuid
, libuv
, lua5_4
, lzfse
, opencl-headers
, SDL2
, SDL2_mixer
, wayland-protocols
, Carbon
, CoreServices
, OpenCL

, callPackage
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vengi-tools";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "mgerhardy";
    repo = "vengi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ljB36A5b8K1KBBuQVISb1fkWxb/tTTwojE31KPMg1xQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    python3
    makeWrapper
  ];

  buildInputs = [
    libbfd
    libdwarf
    backward-cpp
    curl
    enet
    freetype
    glm
    libjpeg
    libuuid
    libuv
    lua5_4
    lzfse
    SDL2
    SDL2_mixer
  ] ++ lib.optional stdenv.hostPlatform.isLinux wayland-protocols
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Carbon CoreServices OpenCL ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) opencl-headers;

  cmakeFlags =
    lib.optional stdenv.hostPlatform.isDarwin "-DCORESERVICES_LIB=${CoreServices}";

  # error: "The plain signature for target_link_libraries has already been used"
  doCheck = false;

  checkInputs = [
    gtest
  ];

  # Set the data directory for each executable. We cannot set it at build time
  # with the PKGDATADIR cmake variable because each executable needs a specific
  # one.
  # This is not needed on darwin, since on that platform data files are saved
  # in *.app/Contents/Resources/ too, and are picked up automatically.
  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" \
        --set CORE_PATH $out/share/$(basename "$prog")/
    done
  '';

  passthru.tests = {
    voxconvert-roundtrip = callPackage ./test-voxconvert-roundtrip.nix {};
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
    broken = stdenv.hostPlatform.isDarwin;
  };
})
