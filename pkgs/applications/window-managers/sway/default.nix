{ stdenv, fetchFromGitHub
, makeWrapper, cmake, pkgconfig, asciidoc, libxslt, docbook_xsl
, wayland, wlc, libxkbcommon, pixman, fontconfig, pcre, json_c, dbus_libs
, pango, cairo, libinput, libcap, xwayland, pam, gdk_pixbuf, libpthreadstubs
, libXdmcp
}:

stdenv.mkDerivation rec {
  name = "sway-${version}";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "Sircmpwn";
    repo = "sway";
    rev = "${version}";
    sha256 = "1l8v9cdzd44bm4q71d47vqg6933b8j42q1a61r362vz2la1rcpq2";
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
