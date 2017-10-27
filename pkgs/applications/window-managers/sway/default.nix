{ stdenv, fetchFromGitHub
, cmake, pkgconfig, asciidoc, libxslt, docbook_xsl
, wayland, wlc, libxkbcommon, pcre, json_c, dbus_libs
, pango, cairo, libinput, libcap, pam, gdk_pixbuf, libpthreadstubs
, libXdmcp
, buildDocs ? true
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
    cmake pkgconfig
  ] ++ stdenv.lib.optional buildDocs [ asciidoc libxslt docbook_xsl ];
  buildInputs = [
    wayland wlc libxkbcommon pcre json_c dbus_libs
    pango cairo libinput libcap pam gdk_pixbuf libpthreadstubs
    libXdmcp
  ];

  enableParallelBuilding = true;

  cmakeFlags = "-DVERSION=${version}";

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = http://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ]; # Trying to keep it up-to-date.
  };
}
