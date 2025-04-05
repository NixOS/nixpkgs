{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jetbrains,
  autoPatchelfHook,
  fontconfig,
  libXinerama,
  libXrandr,
  file,
  gtk3,
  glib,
  cups,
  lcms2,
  alsa-lib,
  libGL,
  libvlc,
  makeDesktopItem,
  copyDesktopItems,
  libidn,
  pulseaudio,
  ffmpeg,
  libva,
  libdvbpsi,
  libogg,
  chromaprint,
  protobuf_21,
  libgcrypt,
  libdvdnav,
  libsecret,
  aribb24,
  libavc1394,
  libmpcdec,
  libvorbis,
  libebml,
  faad2,
  libjpeg8,
  libkate,
  librsvg,
  xorg,
  libsForQt5,
  libupnp,
  aalib,
  libcaca,
  libmatroska,
  libopenmpt-modplug,
  libsidplayfp,
  shine,
  libarchive,
  gnupg,
  srt,
  libshout,
  ffmpeg_6,
  libmpeg2,
  xcbutilkeysyms,
  lirc,
  lua5_2,
  taglib,
  libspatialaudio,
  libmtp,
  speexdsp,
  libsamplerate,
  sox,
  libmad,
  libnotify,
  taglib_1,
  zvbi,
  libdc1394,
  libcddb,
  libbluray,
  libdvdread,
  libvncserver,
  twolame,
  samba,
  libnfs,
  writeShellScript,
  nix-update,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "animeko";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "open-ani";
    repo = "animeko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MU0EFe7JJRyqdEsICNTdnmiOArYvn8KoGe8ZgTpIAXw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    echo "jvm.toolchain.version=21" >> local.properties
  '';

  gradleBuildTask = "createReleaseDistributable";

  gradleUpdateTask = finalAttrs.gradleBuildTask;

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  env.JAVA_HOME = jetbrains.jdk;

  gradleFlags = [ "-Dorg.gradle.java.home=${jetbrains.jdk}" ];

  nativeBuildInputs = [
    gradle
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    fontconfig
    libXinerama
    libXrandr
    file
    shine
    libmpeg2
    gtk3
    glib
    cups
    lcms2
    alsa-lib
    libidn
    pulseaudio
    ffmpeg
    faad2
    libjpeg8
    libkate
    librsvg
    xorg.libXpm
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtx11extras
    libupnp
    aalib
    libcaca
    libva
    libdvbpsi
    libogg
    chromaprint
    protobuf_21
    libgcrypt
    libsecret
    aribb24
    twolame
    libmpcdec
    libvorbis
    libebml
    libmatroska
    libopenmpt-modplug
    libavc1394
    libmtp
    libsidplayfp
    libarchive
    gnupg
    srt
    libshout
    ffmpeg_6
    xcbutilkeysyms
    lirc
    lua5_2
    taglib
    libspatialaudio
    speexdsp
    libsamplerate
    sox
    libmad
    libnotify
    zvbi
    libdc1394
    libcddb
    libbluray
    libdvdread
    libvncserver
    samba
    libnfs
    taglib_1
    libdvdnav
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libmpcdec.so.6"
    "libsidplay2.so.1"
    "libresid-builder.so.0"
    "libsrt-gnutls.so.1.5"
    "liblua5.2.so.0"
    "libspatialaudio.so.0"
    "libdc1394.so.25"
    "libsrt-gnutls.so.1.5"
    "libx265.so.199"
    "libdca.so.0"
    "liba52-0.7.4.so"
  ];

  dontWrapQtApps = true;

  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "animeko";
      exec = "Ani";
      icon = "animeko";
      comment = "集找番、追番、看番的一站式弹幕追番平台";
      desktopName = "Animeko";
      categories = [
        "AudioVideo"
        "Player"
        "Video"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    cp -r app/desktop/build/compose/binaries/main-release/app/Ani $out
    chmod +x $out/lib/runtime/lib/jcef_helper
    install -Dm0644 .github/assets/logo.png $out/share/pixmaps/animeko.png

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libvlc
        ]
      } $out/bin/Ani
  '';

  passthru.updateScript = writeShellScript "update-animeko" ''
    ${lib.getExe nix-update} animeko
    $(nix-build -A animeko.mitmCache.updateScript)
  '';

  meta = {
    description = "One-stop platform for finding, following and watching anime";
    homepage = "https://github.com/open-ani/animeko";
    mainProgram = "Ani";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ emaryn ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    platforms = [ "x86_64-linux" ];
  };
})
