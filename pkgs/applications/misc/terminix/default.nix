{ stdenv, fetchurl, lib, zlib, atk, glib, dbus, gtk3, gnome3
, hicolor_icon_theme, libX11, unzip, gdk_pixbuf, cairo
, libXext, libsecret, makeWrapper }:

stdenv.mkDerivation rec {
  name = "terminix-${version}";
  version = "1.3.5";

  src = fetchurl {
    url = "https://github.com/gnunn1/terminix/releases/download/${version}/terminix.zip";
    sha512 = "c312bfd99ceda3796d03b3fa5c0d1c27992a1c60a40bbe3f06fd004c5f69b1959bc3156b905ed835c0757512bf75feb680bfdd07ab64b6861fc56d5f25eacfa8";
  };

  buildInputs = [ unzip makeWrapper ];


  inherit libX11 libXext;
  buildCommand =

  let

    packages = [
      stdenv.cc.cc zlib glib dbus gtk3 atk
      gdk_pixbuf cairo gnome3.vte libsecret
    ];

    libPathNative = lib.makeLibraryPath packages;
    libPath64 = lib.makeSearchPathOutput "lib" "lib64" packages;
    libPath = "${libPathNative}:${libPath64}";

  in ''
      mkdir -p $out
      cd $out
      unzip $src
      mkdir $out/lib

      #mv $out/usr/* .
      #rm -rf $out/usr

      sed -i "s|Exec=terminix|Exec=$out/usr/bin/terminix|g" $out/usr/share/applications/com.gexperts.Terminix.desktop

      fixupPhase
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "$libX11/lib:$libXext/lib:${libPath}" \
            $out/usr/bin/terminix

      mkdir -p $out/usr/bin/wrapped
      mv "$out/usr/bin/terminix" "$out/usr/bin/wrapped/terminix"
      makeWrapper "$out/usr/bin/wrapped/terminix" "$out/usr/bin/terminix" \
        --prefix XDG_DATA_DIRS : "$out/usr/share:$GSETTINGS_SCHEMAS_PATH" \
        --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"

      ${glib.dev}/bin/glib-compile-schemas $out/usr/share/glib-2.0/schemas

  '';


meta = with stdenv.lib; {
    description = " A tiling terminal emulator for Linux using GTK+ 3 ";
    homepage = https://github.com/gnunn1/terminix;
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.dyrnade ];
  };
}
