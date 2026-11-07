{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  alsa-lib,
  atk,
  bintools,
  brotli,
  bzip2,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gnutls,
  gsm,
  gst_all_1,
  gtk3,
  harfbuzz,
  jbigkit,
  lcms,
  libbluray,
  libcap,
  libdrm,
  libevent,
  libgbm,
  libGL,
  libGLU,
  libinput,
  libjpeg,
  libkrb5,
  libmng,
  libopenmpt,
  libopus,
  libpulseaudio,
  librsvg,
  libssh,
  libtheora,
  libtiff,
  libva,
  libvdpau,
  libvorbis,
  libwebp,
  libxkbcommon,
  libxkbfile,
  # Viber's bundled Qt6WebEngineCore and libavformat need the libxml2.so.2 soname
  libxml2_13,
  libxslt,
  mtdev,
  nspr,
  nss,
  numactl,
  ocl-icd,
  openjpeg,
  openssl,
  pango,
  snappy,
  speex,
  systemdLibs,
  tslib,
  twolame,
  wavpack,
  wayland,
  xkeyboard-config,
  libxcb-wm,
  libxcb-util,
  libxcb-render-util,
  libxcb-keysyms,
  libxcb-image,
  libxtst,
  libxshmfence,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libsm,
  libice,
  libxcb,
  xvidcore,
  zlib,
  zstd,
  zvbi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "viber";
  version = "27.3.0.2";

  src = fetchurl {
    # Taking Internet Archive snapshot of a specific version to avoid breakage
    # on new versions
    url = "https://web.archive.org/web/20260518041738/https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
    hash = "sha256-lhU03Ay5IABux66BCLDhugmkdu7x4TtLNwp5zVLdIPM=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  libPath = lib.makeLibraryPath [
    alsa-lib
    atk
    brotli
    bzip2
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnutls
    gsm
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
    harfbuzz
    jbigkit
    lcms
    libbluray
    libcap
    libdrm
    libevent
    libgbm
    libGL
    libGLU
    libinput
    libjpeg
    libkrb5
    libmng
    libopenmpt
    libopus
    libpulseaudio
    librsvg
    libssh
    libtheora
    libtiff
    libva
    libvdpau
    libvorbis
    libwebp
    libxkbcommon
    libxkbfile
    libxml2_13
    libxslt
    mtdev
    nspr
    nss
    numactl
    ocl-icd
    openjpeg
    openssl
    pango
    snappy
    speex
    stdenv.cc.cc
    systemdLibs
    tslib
    twolame
    wavpack
    wayland
    libice
    libsm
    libx11
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    libxcb
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-util
    libxcb-wm
    xvidcore
    zlib
    zstd
    zvbi
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter ${bintools.dynamicLinker} "$file" || true
      patchelf --set-rpath ${finalAttrs.libPath}:$out/opt/viber/lib $file || true
    done

    mkdir $out/bin
    # qt.conf is not working, so override everything using environment variables
    makeWrapper $out/opt/viber/Viber $out/bin/viber \
      --set QT_QPA_PLATFORM "xcb" \
      --set QT_PLUGIN_PATH "$out/opt/viber/plugins" \
      --set QT_XKB_CONFIG_ROOT "${xkeyboard-config}/share/X11/xkb" \
      --set QTCOMPOSE "${libx11.out}/share/X11/locale" \
      --set QML2_IMPORT_PATH "$out/opt/viber/qml"

    mv $out/usr/share $out/share
    rm -rf $out/usr
    # Fix the desktop link
    substituteInPlace $out/share/applications/viber.desktop \
      --replace-fail "/opt/viber/" "$out/opt/viber/"

    runHook postInstall
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = "https://www.viber.com";
    description = "Instant messaging and Voice over IP (VoIP) app";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
})
