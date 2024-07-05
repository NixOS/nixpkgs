{
  stdenv,
  lib,
  fetchFromGitHub,
  darwin,
  overrideSDK,
  libsForQt5,
  pkg-config,
  vulkan-headers,
  SDL2,
  SDL2_ttf,
  ffmpeg,
  libopus,
  libplacebo,
  openssl,
  alsa-lib,
  libpulseaudio,
  libva,
  libvdpau,
  libxkbcommon,
  wayland,
  nix-update-script,
}:

let
  inherit (darwin.apple_sdk_11_0.frameworks)
    AVFoundation
    AppKit
    AudioUnit
    VideoToolbox
    ;
  stdenv' = if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in

stdenv'.mkDerivation rec {
  pname = "moonlight-qt";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zrl8WPXvQ/7FTqFnpwoXEJ85prtgJWoWNsdckw5+JHI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    pkg-config
    vulkan-headers
  ];

  buildInputs =
    [
      (SDL2.override { drmSupport = stdenv.isLinux; })
      SDL2_ttf
      ffmpeg
      libopus
      libplacebo
      libsForQt5.qtquickcontrols2
      openssl
    ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
      libpulseaudio
      libva
      libvdpau
      libxkbcommon
      wayland
    ]
    ++ lib.optionals stdenv.isDarwin [
      AVFoundation
      AppKit
      AudioUnit
      VideoToolbox
    ];

  qmakeFlags = [ "CONFIG+=disable-prebuilts" ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications $out/bin
    mv app/Moonlight.app $out/Applications
    ln -s $out/Applications/Moonlight.app/Contents/MacOS/Moonlight $out/bin/moonlight
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Play your PC games on almost any device";
    homepage = "https://moonlight-stream.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      azuwis
      luc65r
      zmitchell
    ];
    platforms = platforms.all;
    mainProgram = "moonlight";
  };
}
