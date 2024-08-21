{ lib
, fetchFromGitHub
, callPackage
, pkg-config
, cmake
, ninja
, python3
, gobject-introspection
, wrapGAppsHook3
, wrapQtAppsHook
, extra-cmake-modules
, qtbase
, qtwayland
, qtsvg
, qtimageformats
, gtk3
, glib-networking
, boost
, fmt
, libdbusmenu
, lz4
, xxHash
, ffmpeg
, openalSoft
, minizip
, libopus
, alsa-lib
, libpulseaudio
, pipewire
, range-v3
, tl-expected
, hunspell
, webkitgtk_6_0
, jemalloc
, rnnoise
, protobuf
, abseil-cpp
, xdg-utils
, microsoft-gsl
, rlottie
, ada
, stdenv
, darwin
, lld
, libicns
, nix-update-script
}:

# Main reference:
# - This package was originally based on the Arch package but all patches are now upstreamed:
#   https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/telegram-desktop
# Other references that could be useful:
# - https://git.alpinelinux.org/aports/tree/testing/telegram-desktop/APKBUILD
# - https://github.com/void-linux/void-packages/blob/master/srcpkgs/telegram-desktop/template

let
  tg_owt = callPackage ./tg_owt.nix {
    inherit stdenv;
    abseil-cpp = abseil-cpp.override {
      cxxStandard = "20";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "telegram-desktop";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "telegramdesktop";
    repo = "tdesktop";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-AWu0LH6DH/omcIsgIBHQIg1uCKN9Ly6EVj4U9QxoSlg=";
  };

  patches = [
    ./macos.patch
    # the generated .desktop files contains references to unwrapped tdesktop, breaking scheme handling
    # and the scheme handler is already registered in the packaged .desktop file, rendering this unnecessary
    # see https://github.com/NixOS/nixpkgs/issues/218370
    ./scheme.patch
  ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioInputALSA.cpp \
      --replace-fail '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioOutputALSA.cpp \
      --replace-fail '"libasound.so.2"' '"${alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioPulse.cpp \
      --replace-fail '"libpulse.so.0"' '"${libpulseaudio}/lib/libpulse.so.0"'
    substituteInPlace Telegram/lib_webview/webview/platform/linux/webview_linux_webkitgtk_library.cpp \
      --replace-fail '"libwebkitgtk-6.0.so.4"' '"${webkitgtk_6_0}/lib/libwebkitgtk-6.0.so.4"'
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Telegram/lib_webrtc/webrtc/platform/mac/webrtc_environment_mac.mm \
      --replace-fail kAudioObjectPropertyElementMain kAudioObjectPropertyElementMaster
  '';

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    python3
    wrapQtAppsHook
  ] ++ lib.optionals stdenv.isLinux [
    gobject-introspection
    wrapGAppsHook3
    extra-cmake-modules
  ] ++ lib.optionals stdenv.isDarwin [
    lld
  ];

  buildInputs = [
    qtbase
    qtsvg
    qtimageformats
    boost
    lz4
    xxHash
    ffmpeg
    openalSoft
    minizip
    libopus
    range-v3
    tl-expected
    rnnoise
    protobuf
    tg_owt
    microsoft-gsl
    rlottie
    ada
  ] ++ lib.optionals stdenv.isLinux [
    qtwayland
    gtk3
    glib-networking
    fmt
    libdbusmenu
    alsa-lib
    libpulseaudio
    pipewire
    hunspell
    webkitgtk_6_0
    jemalloc
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
    Cocoa
    CoreFoundation
    CoreServices
    CoreText
    CoreGraphics
    CoreMedia
    OpenGL
    AudioUnit
    ApplicationServices
    Foundation
    AGL
    Security
    SystemConfiguration
    Carbon
    AudioToolbox
    VideoToolbox
    VideoDecodeAcceleration
    AVFoundation
    CoreAudio
    CoreVideo
    CoreMediaIO
    QuartzCore
    AppKit
    CoreWLAN
    WebKit
    IOKit
    GSS
    MediaPlayer
    IOSurface
    Metal
    NaturalLanguage
    LocalAuthentication
    libicns
  ]);

  env = lib.optionalAttrs stdenv.isDarwin {
    NIX_CFLAGS_LINK = "-fuse-ld=lld";
  };

  cmakeFlags = [
    (lib.cmakeBool "DESKTOP_APP_DISABLE_AUTOUPDATE" true)
    # We're allowed to used the API ID of the Snap package:
    (lib.cmakeFeature "TDESKTOP_API_ID" "611335")
    (lib.cmakeFeature "TDESKTOP_API_HASH" "d524b414d21f4d37f08684c1df41ac9c")
    # See: https://github.com/NixOS/nixpkgs/pull/130827#issuecomment-885212649
    (lib.cmakeBool "DESKTOP_APP_USE_PACKAGED_FONTS" false)
  ];

  preBuild = ''
    # for cppgir to locate gir files
    export GI_GIR_PATH="$XDG_DATA_DIRS"
  '';

  installPhase = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r ${finalAttrs.meta.mainProgram}.app $out/Applications
    ln -s $out/{Applications/${finalAttrs.meta.mainProgram}.app/Contents/MacOS,bin}
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    # This is necessary to run Telegram in a pure environment.
    # We also use gappsWrapperArgs from wrapGAppsHook.
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '' + lib.optionalString stdenv.isDarwin ''
    wrapQtApp $out/Applications/${finalAttrs.meta.mainProgram}.app/Contents/MacOS/${finalAttrs.meta.mainProgram}
  '';

  passthru = {
    inherit tg_owt;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Telegram Desktop messaging app";
    longDescription = ''
      Desktop client for the Telegram messenger, based on the Telegram API and
      the MTProto secure protocol.
    '';
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    homepage = "https://desktop.telegram.org/";
    changelog = "https://github.com/telegramdesktop/tdesktop/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = if stdenv.hostPlatform.isLinux then "telegram-desktop" else "Telegram";
  };
})
