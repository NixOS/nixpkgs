{ gcc11Stdenv, lib, fetchFromGitHub, wrapQtAppsHook, cmake, pkg-config, git
, qtbase, qtquickcontrols, qtmultimedia, openal, glew, vulkan-headers, vulkan-loader, libpng
, ffmpeg, libevdev, libusb1, zlib, curl, wolfssl, python3, pugixml, faudio, flatbuffers
, sdl2Support ? true, SDL2
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsa-lib
}:

let
  # Keep these separate so the update script can regex them
  rpcs3GitVersion = "14141-d686b48f6";
  rpcs3Version = "0.0.24-14141-d686b48f6";
  rpcs3Revision = "d686b48f6549c736661e14d1e0990b043c32e3c2";
  rpcs3Sha256 = "1jzpb189isy9kc6l5cy1nfx0wq5cri753sh32b1xq259lkqihdp5";

  ittapi = fetchFromGitHub {
    owner = "intel";
    repo = "ittapi";
    rev = "v3.18.12";
    sha256 = "0c3g30rj1y8fbd2q4kwlpg1jdy02z4w5ryhj3yr9051pdnf4kndz";
  };
in
gcc11Stdenv.mkDerivation {
  pname = "rpcs3";
  version = rpcs3Version;

  src = fetchFromGitHub {
    owner = "RPCS3";
    repo = "rpcs3";
    rev = rpcs3Revision;
    fetchSubmodules = true;
    sha256 = rpcs3Sha256;
  };

  patches = [ ./0001-llvm-ExecutionEngine-IntelJITEvents-only-use-ITTAPI_.patch ];

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
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
    "-DITTAPI_SOURCE_DIR=${ittapi}"
  ];

  nativeBuildInputs = [ cmake pkg-config git wrapQtAppsHook ];

  buildInputs = [
    qtbase qtquickcontrols qtmultimedia openal glew vulkan-headers vulkan-loader libpng ffmpeg
    libevdev zlib libusb1 curl wolfssl python3 pugixml faudio flatbuffers
  ] ++ lib.optional sdl2Support SDL2
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsa-lib
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
    platforms = [ "x86_64-linux" ];
  };
}
