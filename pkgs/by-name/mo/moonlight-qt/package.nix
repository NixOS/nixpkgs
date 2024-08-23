{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  darwin,
  overrideSDK,
  qt6,
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
  libdrm,
  nix-update-script,
}:

let
  inherit (darwin.apple_sdk_11_0.frameworks)
    AVFoundation
    AppKit
    AudioUnit
    Cocoa
    VideoToolbox
    ;
  stdenv' = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
in

stdenv'.mkDerivation rec {
  pname = "moonlight-qt";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zrl8WPXvQ/7FTqFnpwoXEJ85prtgJWoWNsdckw5+JHI=";
    fetchSubmodules = true;
  };

  patches = [
    # Don't precompile QML files with disable-prebuilts, fix build on darwin
    (fetchpatch {
      url = "https://github.com/moonlight-stream/moonlight-qt/commit/d73df12367749425b86b72c250bb0fba13ddfd29.patch";
      hash = "sha256-RIrQpZWbwUHs1Iwz/pXfXgshJeHYrzGxuaR5mRG85QY=";
    })
  ];

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
    pkg-config
    vulkan-headers
  ];

  buildInputs =
    [
      (SDL2.override { drmSupport = stdenv.hostPlatform.isLinux; })
      SDL2_ttf
      ffmpeg
      libopus
      libplacebo
      qt6.qtdeclarative
      qt6.qtsvg
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libpulseaudio
      libva
      libvdpau
      libxkbcommon
      qt6.qtwayland
      wayland
      libdrm
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AVFoundation
      AppKit
      AudioUnit
      Cocoa
      VideoToolbox
    ];

  qmakeFlags = [ "CONFIG+=disable-prebuilts" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
