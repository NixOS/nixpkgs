{ stdenv, fetchFromGitHub, pango, libinput
, makeWrapper, cmake, pkgconfig, asciidoc, libxslt, docbook_xsl, cairo
, wayland, wlc, libxkbcommon, pixman, fontconfig, pcre, json_c, dbus_libs, libcap
, xwayland, pam, gdk_pixbuf
}:

let
  version = "0.12.2";
in
  stdenv.mkDerivation rec {
    name = "sway-${version}";

    src = fetchFromGitHub {
      owner = "Sircmpwn";
      repo = "sway";
      rev = "${version}";
      sha256 = "1hkr6pmz45xa5w5y21ijz7i2dwb62rifhcy28r8kh5r2hwbil2hs";
    };

    nativeBuildInputs = [ makeWrapper cmake pkgconfig asciidoc libxslt docbook_xsl ];

    buildInputs = [ wayland wlc libxkbcommon pixman fontconfig pcre json_c dbus_libs pango cairo libinput libcap xwayland pam gdk_pixbuf ];

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
