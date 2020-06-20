{ stdenv, lib, fetchurl, unzip, glib, systemd, nss, nspr, gtk3-x11, gnome2,
atk, cairo, gdk-pixbuf, xorg, xorg_sys_opengl, utillinux, alsaLib, dbus, at-spi2-atk,
cups, vivaldi-ffmpeg-codecs, libpulseaudio, at-spi2-core }:

stdenv.mkDerivation rec {
  pname = "exodus";
  version = "20.1.30";

  src = fetchurl {
    url = "https://downloads.exodus.io/releases/${pname}-linux-x64-${version}.zip";
    sha256 = "0jns5zqjm0gqn18ypghbgk6gb713mh7p44ax1r8y4vcwijlp5nql";
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
          --replace 'Exec=bash -c "cd `dirname %k` && ./Exodus"' "Exec=Exodus"
  '';

  dontPatchELF = true;
  dontBuild = true;

  preFixup = let
    libPath = lib.makeLibraryPath [
      glib
      nss
      nspr
      gtk3-x11
      gnome2.pango
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
      xorg.libXtst
      xorg_sys_opengl
      utillinux
      xorg.libXrandr
      xorg.libXScrnSaver
      alsaLib
      dbus.lib
      at-spi2-atk
      at-spi2-core
      cups.lib
      libpulseaudio
      systemd
      vivaldi-ffmpeg-codecs
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/Exodus
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.exodus.io/";
    description = "Top-rated cryptocurrency wallet with Trezor integration and built-in Exchange";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.mmahut ];
  };
}
