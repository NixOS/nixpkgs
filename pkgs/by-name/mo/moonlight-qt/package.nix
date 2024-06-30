{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tXlcHQhXnGdZqUlOHPN1f4vaGlF/kGkTybVW/+FMGX8=";
    fetchSubmodules = true;
  };

  patches = [
    # Add 'CONFIG+=disable-prebuilts' qmake option
    # When specified, qmake uses pkg-config for libraries on macOS instead of the prebuilts in the libs submodule.
    (fetchpatch {
      url = "https://github.com/moonlight-stream/moonlight-qt/commit/83811e2a077b78409cf79ed77b8437041159ad88.patch";
      hash = "sha256-JlYtUiY0jJMNjF4KWpo58MOGufbl+od+UC+uxmu3ZF4=";
    })
    # Don't bundle libs into the final app package if disable-prebuilts is set
    (fetchpatch {
      url = "https://github.com/moonlight-stream/moonlight-qt/commit/640ac3f9fe90197c826c9694942b9cd7be53f757.patch";
      hash = "sha256-l7bpkR9f3+Xwx5e7p9IGddjHrV77BrCHkTQ9cwDyYeY=";
    })
  ];

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
      luc65r
      zmitchell
    ];
    platforms = platforms.all;
    mainProgram = "moonlight";
  };
}
