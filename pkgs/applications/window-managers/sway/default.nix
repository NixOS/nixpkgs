{ stdenv, fetchFromGitHub
, makeWrapper, cmake, pkgconfig, asciidoc, libxslt, docbook_xsl
, wayland, wlc, libxkbcommon, pixman, fontconfig, pcre, json_c, dbus_libs
, pango, cairo, libinput, libcap, xwayland, pam, gdk_pixbuf, libpthreadstubs
, libXdmcp
}:

let
  # TODO: Sway 0.14.0 with wlc 0.0.10 segfaults
  version = "0.13.0";
in stdenv.mkDerivation rec {
  name = "sway-${version}";

  src = fetchFromGitHub {
    owner = "Sircmpwn";
    repo = "sway";
    rev = "${version}";
    sha256 = "1vgk4rl51nx66yzpwg4yhnbj7wc30k5q0hh5lf8y0i1nvpal0p3q";
  };

  nativeBuildInputs = [
    makeWrapper cmake pkgconfig
    asciidoc libxslt docbook_xsl
  ];
  buildInputs = [
    wayland wlc libxkbcommon pixman fontconfig pcre json_c dbus_libs
    pango cairo libinput libcap xwayland pam gdk_pixbuf libpthreadstubs
    libXdmcp
  ];

  patchPhase = ''
    sed -i s@/etc/sway@$out/etc/sway@g CMakeLists.txt;
  '';

  makeFlags = "PREFIX=$(out)";
  cmakeFlags = "-DVERSION=${version}";
  installPhase = "PREFIX=$out make install";

  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath [ wlc dbus_libs ];
  preFixup = ''
    wrapProgram $out/bin/sway \
      --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}";
  '';

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = http://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ]; # Trying to keep it up-to-date.
  };
}
