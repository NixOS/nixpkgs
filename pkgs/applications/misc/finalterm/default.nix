{ stdenv, lib, fetchgit, makeWrapper
, pkgconfig, cmake, libxml2, vala_0_23, intltool, libmx, gnome3, gtk3, gtk_doc
, keybinder3, clutter_gtk, libnotify
, libxkbcommon, xorg, udev
, bashInteractive
}:

stdenv.mkDerivation {
  name = "finalterm-git-2014-11-15";

  src = fetchgit {
    url = "https://github.com/p-e-w/finalterm.git";
    rev = "39b078b2a96a5c3c9e74f92b1929f383d220ca8b";
    sha256 = "14viln5nabr39lafg1lzf6ydibz1h5d9346drp435ljxc6wsh21i";
  };

  buildInputs = [
    pkgconfig cmake vala_0_23 intltool gtk3 gnome3.gnome_common gnome3.libgee
    gtk_doc clutter_gtk libmx keybinder3 libxml2 libnotify makeWrapper
    xorg.libpthreadstubs xorg.libXdmcp xorg.libxshmfence
    libxkbcommon
  ] ++ lib.optionals stdenv.isLinux [
    udev
  ];

  preConfigure = ''
    substituteInPlace data/org.gnome.finalterm.gschema.xml \
      --replace "/bin/bash" "${bashInteractive}/bin/bash"

    cmakeFlagsArray=(
      -DMINIMAL_FLAGS=ON
    )
  '';

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/$name
    mv $out/share/glib-2.0 $out/share/gsettings-schemas/$name/
  '';

  postFixup = ''
    wrapProgram "$out/bin/finalterm" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gnome3.defaultIconTheme}/share:${gnome3.gtk.out}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with lib; {
    homepage = "http://finalterm.org";
    description = "A new breed of terminal emulator";
    longDescription = ''
      Final Term is a new breed of terminal emulator.

      It goes beyond mere emulation and understands what is happening inside the shell it is hosting. This allows it to offer features no other terminal can, including:

      - Semantic text menus
      - Smart command completion
      - GUI terminal controls
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.linux;
  };
}
