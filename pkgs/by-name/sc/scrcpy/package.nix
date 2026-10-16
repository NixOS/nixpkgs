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
  libdrm,
  libusb1,
  sdl3,
}:

let
  version = "5.0.1";
  prebuilt_server = fetchurl {
    name = "scrcpy-server";
    inherit version;
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}";
    hash = "sha256-dk6295gR1SEf6d80ESCIK6mZTHphuJfXvz+2YuU7xTY=";
  };
in
stdenv.mkDerivation {
  pname = "scrcpy";
  inherit version;

  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = "scrcpy";
    tag = "v${version}";
    hash = "sha256-zms3jDqo8CgIyaAglw13dAF0OP7mCP18Z2nIWyq0Thg=";
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
    libusb1
    sdl3
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libdrm
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
