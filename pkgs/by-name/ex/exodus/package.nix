{
  stdenv,
  lib,
  requireFile,
  unzip,
  glib,
  systemd,
  nss,
  nspr,
  gtk3-x11,
  pango,
  atk,
  cairo,
  gdk-pixbuf,
  libxtst,
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
  libxshmfence,
  libxcb,
  xorg_sys_opengl,
  util-linux,
  alsa-lib,
  dbus,
  at-spi2-atk,
  cups,
  vivaldi-ffmpeg-codecs,
  libpulseaudio,
  at-spi2-core,
  libxkbcommon,
  libgbm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exodus";
  version = "25.28.4";

  src = requireFile {
    name = "exodus-linux-x64-${finalAttrs.version}.zip";
    url = "https://downloads.exodus.com/releases/exodus-linux-x64-${finalAttrs.version}.zip";
    hash = "sha256-AGeFsMHSywC32iaIGI9/VY2YC3gR5bHu33rOWJlyFFM=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    cp -r . $out
    ln -s $out/Exodus $out/bin/Exodus
    ln -s $out/bin/Exodus $out/bin/exodus
    ln -s $out/exodus.desktop $out/share/applications
    substituteInPlace $out/share/applications/exodus.desktop \
          --replace-fail 'Exec=bash -c "cd \\`dirname %k\\` && ./Exodus %u"' "Exec=Exodus %u"
  '';

  dontPatchELF = true;
  dontBuild = true;

  preFixup =
    let
      libPath = lib.makeLibraryPath [
        glib
        nss
        nspr
        gtk3-x11
        pango
        atk
        cairo
        gdk-pixbuf
        libx11
        libxcb
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxrender
        libxshmfence
        libxtst
        xorg_sys_opengl
        util-linux
        libxrandr
        libxscrnsaver
        alsa-lib
        dbus.lib
        at-spi2-atk
        at-spi2-core
        cups.lib
        libpulseaudio
        systemd
        vivaldi-ffmpeg-codecs
        libxkbcommon
        libgbm
      ];
    in
    ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/Exodus
    '';

  meta = {
    homepage = "https://www.exodus.io/";
    description = "Top-rated cryptocurrency wallet with Trezor integration and built-in Exchange";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mmahut
      rople380
      Crafter
    ];
  };
})
