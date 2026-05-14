{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  installShellFiles,

  android-tools,
  ffmpeg,
  libusb1,
  sdl3,
}:

let
  version = "4.0";
  prebuilt_server = fetchurl {
    name = "scrcpy-server";
    inherit version;
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}";
    hash = "sha256-hJJL1WSh62CJyHLHUh+WgFiXf5H1/wJRSox0r/MhDzo=";
  };
in
stdenv.mkDerivation rec {
  pname = "scrcpy";
  inherit version;

  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = "scrcpy";
    tag = "v${version}";
    hash = "sha256-o8jZXVwNub8KU7k2BjC9jvpX4Y7bKFySBUYw/dVHck0=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    ffmpeg
    sdl3
    libusb1
  ];

  # Manually install the server jar to prevent Meson from "fixing" it
  preConfigure = ''
    echo -n > server/meson.build
  '';

  postInstall = ''
    mkdir -p "$out/share/scrcpy"
    ln -s "${prebuilt_server}" "$out/share/scrcpy/scrcpy-server"

    # runtime dep on `adb` to push the server
    wrapProgram "$out/bin/scrcpy" --prefix PATH : "${android-tools}/bin"
  '';

  meta = {
    description = "Display and control Android devices over USB or TCP/IP";
    homepage = "https://github.com/Genymobile/scrcpy";
    changelog = "https://github.com/Genymobile/scrcpy/releases/tag/v${version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # server
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      deltaevo
      ryand56
    ];
    mainProgram = "scrcpy";
  };
}
