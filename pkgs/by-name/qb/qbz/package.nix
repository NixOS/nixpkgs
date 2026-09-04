{
  alsa-lib,
  cmake,
  fetchFromGitHub,
  lib,
  libjack2,
  nasm,
  nix-update-script,
  pipewire, # pw-metadata/pw-dump for bit-perfect sample rate queries and DAC detection
  pkg-config,
  pulseaudio, # pactl for PipeWire device enumeration and sink routing
  qt6,
  rustPlatform,
  xdg-utils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qbz";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "vicrodh";
    repo = "qbz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yc5f7DjAFAjYgTnT2yv7zjIxmXPJ8ZdLaoPnHJoFRX0=";
  };

  cargoHash = "sha256-XrioYToGvA0nN4D5UOvKP8xeFRCL0J/p5bMneWZRO1w=";
  cargoRoot = "crates";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  # Ship both released binaries: the Qt GUI (qbz-qt, installed as `qbz`) and
  # the headless daemon (qbzd). Upstream releases both.
  cargoBuildFlags = [
    "-p"
    "qbz-qt"
    "-p"
    "qbzd"
  ];

  # cmake: cxx-qt-build drives the generated C++ side through it. nasm:
  # aws-lc-sys (TLS) assembles its primitives with it. qt6.qmake +
  # wrapQtAppsHook: the 2.1 frontend is Qt Quick, so the build needs qmake and
  # the wrapper sets the Qt plugin/QML paths the binary loads at run time. (The
  # 1.x/2.0 Slint build also needed clang; the Qt build does not, so it is
  # dropped.)
  nativeBuildInputs = [
    cmake
    nasm
    pkg-config
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  # cxx-qt needs qtbase + qtdeclarative (the RHI scene items include
  # <rhi/qrhi.h>). qtsvg is the SVG image plugin; qtwayland the Wayland
  # platform plugin. wrapQtAppsHook pulls in the rest of Qt's runtime closure.
  buildInputs = [
    alsa-lib
    libjack2
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwayland
  ];

  # Runtime helpers QBZ shells out to: pactl/pw-* for device enumeration and
  # sample-rate control, xdg-open for external links. libjack2 is dlopened by
  # the JACK backend, so it must be on LD_LIBRARY_PATH; the rest of the runtime
  # library closure comes from wrapQtAppsHook + buildInputs.
  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        pipewire
        pulseaudio
        xdg-utils
      ]
    }"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}"
  ];

  # Tests need an offscreen QPA + D-Bus the sandbox does not provide; the
  # engine crates are covered by upstream CI (test-crates.yml).
  doCheck = false;

  postInstall = ''
    install -Dm644 $src/packaging/linux/qbz.desktop \
      $out/share/applications/com.blitzfc.qbz.desktop
    install -Dm644 $src/packaging/flatpak/com.blitzfc.qbz.metainfo.xml \
      $out/share/metainfo/com.blitzfc.qbz.metainfo.xml
    for size in 32 48 64 128 256 512; do
      install -Dm644 $src/packaging/icons/"$size"x"$size".png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/qbz.png
    done
    install -Dm644 $src/LICENSE $out/share/licenses/qbz/LICENSE
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native, full-featured hi-fi Qobuz desktop player for Linux, with fast, bit-perfect audio playback";
    homepage = "https://qbz.lol";
    changelog = "https://github.com/vicrodh/qbz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felixsinger
      vicrodh
      fpletz
    ];
    mainProgram = "qbz";
    platforms = lib.platforms.linux;
  };
})
