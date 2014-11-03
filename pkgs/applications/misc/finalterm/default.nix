{ stdenv, lib, fetchFromGitHub, makeWrapper
, pkgconfig, cmake, libxml2, vala, intltool, libmx, gnome3, gtk3, gtk_doc
, keybinder3, clutter_gtk, libnotify
, libxkbcommon, xlibs, udev
, bashInteractive
}:

let rev = "5ccde4e8f2c02a398f9172e07c25262ecf954626";
in stdenv.mkDerivation {
  name = "finalterm-git-${builtins.substring 0 8 rev}";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "finalterm";
    inherit rev;
    sha256 = "1gw6nc19whfjd4xj0lc0fmjypn8d7nasif79671859ymnfizyq4f";
  };

  buildInputs = [
    pkgconfig cmake vala intltool gtk3 gnome3.gnome_common gnome3.libgee
    gtk_doc clutter_gtk libmx keybinder3 libxml2 libnotify makeWrapper
    xlibs.libpthreadstubs xlibs.libXdmcp xlibs.libxshmfence
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

  postFixup = ''
    wrapProgram "$out/bin/finalterm" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_icon_theme}/share:${gnome3.gtk}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
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
    platforms = with platforms; linux;
  };
}
