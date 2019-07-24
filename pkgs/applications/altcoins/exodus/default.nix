{ stdenv, lib, fetchurl, unzip, glib, systemd, nss, nspr, gtk3-x11, gnome2,
atk, cairo, gdk-pixbuf, xorg, xorg_sys_opengl, utillinux, alsaLib, dbus, at-spi2-atk,
cups, vivaldi-ffmpeg-codecs, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "exodus";
  version = "19.5.24";

  src = fetchurl {
    url = "https://exodusbin.azureedge.net/releases/${pname}-linux-x64-${version}.zip";
    sha256 = "1yx296i525qmpqh8f2vax7igffg826nr8cyq1l0if35374bdsqdw";
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
