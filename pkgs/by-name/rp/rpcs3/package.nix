{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, git
, qt6Packages
, openal
, glew
, vulkan-headers
, vulkan-loader
, libpng
, libSM
, ffmpeg
, libevdev
, libusb1
, zlib
, curl
, wolfssl
, python3
, pugixml
, flatbuffers
, llvm_16
, cubeb
, faudioSupport ? true
, faudio
, SDL2
, waylandSupport ? true
, wayland
}:

let
  # Keep these separate so the update script can regex them
  rpcs3GitVersion = "15726-ebf48800e";
  rpcs3Version = "0.0.29-15726-ebf48800e";
  rpcs3Revision = "ebf48800e6bf2569fa0a59974ab2daaeb3a92f23";
  rpcs3Hash = "sha256-HJQ+DCZy8lwMCfq0N9StKD8bP1hCBxGMAucbQ9esy/I=";

  inherit (qt6Packages) qtbase qtmultimedia wrapQtAppsHook;
in
stdenv.mkDerivation {
  pname = "rpcs3";
  version = rpcs3Version;

  src = fetchFromGitHub {
    owner = "RPCS3";
    repo = "rpcs3";
    rev = rpcs3Revision;
    fetchSubmodules = true;
    hash = rpcs3Hash;
  };

  passthru.updateScript = ./update.sh;

  preConfigure = ''
    cat > ./rpcs3/git-version.h <<EOF
    #define RPCS3_GIT_VERSION "${rpcs3GitVersion}"
    #define RPCS3_GIT_FULL_BRANCH "RPCS3/rpcs3/master"
    #define RPCS3_GIT_BRANCH "HEAD"
    #define RPCS3_GIT_VERSION_NO_UPDATE 1
    EOF
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_ZLIB=ON"
    "-DUSE_SYSTEM_LIBUSB=ON"
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_SYSTEM_CURL=ON"
    "-DUSE_SYSTEM_WOLFSSL=ON"
    "-DUSE_SYSTEM_FAUDIO=ON"
    "-DUSE_SYSTEM_PUGIXML=ON"
    "-DUSE_SYSTEM_FLATBUFFERS=ON"
    "-DUSE_SYSTEM_SDL=ON"
    "-DWITH_LLVM=ON"
    "-DBUILD_LLVM=OFF"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
    "-DUSE_FAUDIO=${if faudioSupport then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [ cmake pkg-config git wrapQtAppsHook ];

  buildInputs = [
    qtbase qtmultimedia openal glew vulkan-headers vulkan-loader libpng ffmpeg
    libevdev zlib libusb1 curl wolfssl python3 pugixml flatbuffers llvm_16 libSM
  ] ++ cubeb.passthru.backendLibs
    ++ lib.optionals faudioSupport [ faudio SDL2 ]
    ++ lib.optional waylandSupport wayland;

  postInstall = ''
    # Taken from https://wiki.rpcs3.net/index.php?title=Help:Controller_Configuration
    install -D ${./99-ds3-controllers.rules} $out/etc/udev/rules.d/99-ds3-controllers.rules
    install -D ${./99-ds4-controllers.rules} $out/etc/udev/rules.d/99-ds4-controllers.rules
    install -D ${./99-dualsense-controllers.rules} $out/etc/udev/rules.d/99-dualsense-controllers.rules
  '';

  meta = with lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar neonfuz ilian zane ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "rpcs3";
  };
}
