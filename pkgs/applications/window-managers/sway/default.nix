{ stdenv, fetchFromGitHub, pango, libinput
, makeWrapper, cmake, pkgconfig, asciidoc, libxslt, docbook_xsl, cairo
, wayland, wlc, libxkbcommon, pixman, fontconfig, pcre, json_c, dbus_libs
}:

stdenv.mkDerivation rec {
  name = "sway-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "Sircmpwn";
    repo = "sway";
    rev = "0.7";
    sha256 = "05mn68brqz7j3a1sb5xd3pxzzdd8swnhw2g7cc9f7rdjr5dlrjip";
  };

  nativeBuildInputs = [ makeWrapper cmake pkgconfig asciidoc libxslt docbook_xsl ];

  buildInputs = [ wayland wlc libxkbcommon pixman fontconfig pcre json_c dbus_libs pango cairo libinput ];

  patchPhase = ''
    sed -i s@/etc/sway@$out/etc/sway@g CMakeLists.txt;
  '';

  makeFlags = "PREFIX=$(out)";
  installPhase = "PREFIX=$out make install";

  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath [ wlc dbus_libs ];
  preFixup = ''
    wrapProgram $out/bin/sway \
      --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}";
  '';

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = "http://swaywm.org";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
