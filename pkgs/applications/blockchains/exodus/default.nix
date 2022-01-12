{ stdenv, lib, fetchurl, unzip, glib, systemd, nss, nspr, gtk3-x11, pango,
atk, cairo, gdk-pixbuf, xorg, xorg_sys_opengl, util-linux, alsa-lib, dbus, at-spi2-atk,
cups, vivaldi-ffmpeg-codecs, libpulseaudio, at-spi2-core, libxkbcommon, mesa }:

stdenv.mkDerivation rec {
  pname = "exodus";
  version = "21.10.25";

  src = fetchurl {
    url = "https://downloads.exodus.io/releases/${pname}-linux-x64-${version}.zip";
    sha256 = "a85ddda4e73dfadddbb77cf9bc84c30fc6b893ead46367d702976bbf4da5afa4";
  };

  sourceRoot = ".";
  unpackCmd = ''
      ${unzip}/bin/unzip "$src" -x "Exodus*/lib*so"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    cd Exodus-linux-x64
    cp -r . $out
    ln -s $out/Exodus $out/bin/Exodus
    ln -s $out/bin/Exodus $out/bin/exodus
    ln -s $out/exodus.desktop $out/share/applications
    substituteInPlace $out/share/applications/exodus.desktop \
          --replace 'Exec=bash -c "cd \`dirname %k\` && ./Exodus %u"' "Exec=Exodus %u"
  '';

  dontPatchELF = true;
  dontBuild = true;

  preFixup = let
    libPath = lib.makeLibraryPath [
      glib
      nss
      nspr
      gtk3-x11
      pango
      atk
      cairo
      gdk-pixbuf
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrender
      xorg.libxshmfence
      xorg.libXtst
      xorg_sys_opengl
      util-linux
      xorg.libXrandr
      xorg.libXScrnSaver
      alsa-lib
      dbus.lib
      at-spi2-atk
      at-spi2-core
      cups.lib
      libpulseaudio
      systemd
      vivaldi-ffmpeg-codecs
      libxkbcommon
      mesa
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/Exodus
  '';

  meta = with lib; {
    homepage = "https://www.exodus.io/";
    description = "Top-rated cryptocurrency wallet with Trezor integration and built-in Exchange";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mmahut rople380 ];
  };
}
