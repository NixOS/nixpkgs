{ stdenv, fetchFromGitHub
, makeWrapper, cmake, pkgconfig, asciidoc, libxslt, docbook_xsl
, wayland, wlc, libxkbcommon, pixman, fontconfig, pcre, json_c, dbus_libs
}:

stdenv.mkDerivation rec {
  name = "sway-${version}";
  version = "git-2016-02-08";

  src = fetchFromGitHub {
    owner = "Sircmpwn";
    repo = "sway";

    rev = "16e904634c65128610537bed7fcb16ac3bb45165";
    sha256 = "04qvdjaarglq3qsjbb9crjkad3y1v7s51bk82sl8w26c71jbhklg";
  };

  nativeBuildInputs = [ makeWrapper cmake pkgconfig asciidoc libxslt docbook_xsl ];

  buildInputs = [ wayland wlc libxkbcommon pixman fontconfig pcre json_c dbus_libs ];

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
