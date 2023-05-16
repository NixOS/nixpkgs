<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, pkg-config
, git
, qtbase
, qtquickcontrols
, qtmultimedia
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
=======
{ lib, stdenv, fetchFromGitHub, wrapQtAppsHook, cmake, pkg-config, git
, qtbase, qtquickcontrols, qtmultimedia, openal, glew, vulkan-headers, vulkan-loader, libpng
, ffmpeg, libevdev, libusb1, zlib, curl, wolfssl, python3, pugixml, faudio, flatbuffers
, sdl2Support ? true, SDL2
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsa-lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  # Keep these separate so the update script can regex them
<<<<<<< HEAD
  rpcs3GitVersion = "15409-fd6829f75";
  rpcs3Version = "0.0.28-15409-fd6829f75";
  rpcs3Revision = "fd6829f7576da07e3bb90de8821834d3ce44610c";
  rpcs3Hash = "sha256-I/CYDE7te8xxKjTyH1Mb45uemya5Sfjb96MQWlkFAbk=";
=======
  rpcs3GitVersion = "14840-842edbcbe";
  rpcs3Version = "0.0.27-14840-842edbcbe";
  rpcs3Revision = "842edbcbe795941981993c667c2d8a866126b5b0";
  rpcs3Sha256 = "1al4dx93f02k56k62dxjqqb46cwg0nkpjax1xnjc8v3bx4gsp6f6";

  ittapi = fetchFromGitHub {
    owner = "intel";
    repo = "ittapi";
    rev = "v3.18.12";
    sha256 = "0c3g30rj1y8fbd2q4kwlpg1jdy02z4w5ryhj3yr9051pdnf4kndz";
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
stdenv.mkDerivation {
  pname = "rpcs3";
  version = rpcs3Version;

  src = fetchFromGitHub {
    owner = "RPCS3";
    repo = "rpcs3";
    rev = rpcs3Revision;
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = rpcs3Hash;
  };

=======
    sha256 = rpcs3Sha256;
  };

  patches = [ ./0001-llvm-ExecutionEngine-IntelJITEvents-only-use-ITTAPI_.patch ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    "-DUSE_SYSTEM_SDL=ON"
    "-DWITH_LLVM=ON"
    "-DBUILD_LLVM=OFF"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
    "-DUSE_FAUDIO=${if faudioSupport then "ON" else "OFF"}"
=======
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
    "-DITTAPI_SOURCE_DIR=${ittapi}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeBuildInputs = [ cmake pkg-config git wrapQtAppsHook ];

  buildInputs = [
    qtbase qtquickcontrols qtmultimedia openal glew vulkan-headers vulkan-loader libpng ffmpeg
<<<<<<< HEAD
    libevdev zlib libusb1 curl wolfssl python3 pugixml flatbuffers llvm_16 libSM
  ] ++ cubeb.passthru.backendLibs
    ++ lib.optionals faudioSupport [ faudio SDL2 ]
=======
    libevdev zlib libusb1 curl wolfssl python3 pugixml faudio flatbuffers
  ] ++ lib.optional sdl2Support SDL2
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsa-lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "rpcs3";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
