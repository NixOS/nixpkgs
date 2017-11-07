{ stdenv, fetchFromGitHub
, cmake, pkgconfig, asciidoc, libxslt, docbook_xsl
, wayland, wlc, libxkbcommon, pcre, json_c, dbus_libs
, pango, cairo, libinput, libcap, pam, gdk_pixbuf, libpthreadstubs
, libXdmcp
, buildDocs ? true
}:

stdenv.mkDerivation rec {
  name = "sway-${version}";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "0rz5rgap2ah7hkk4glvlmjq0c8i2f47qzkwjx7gm4wmb8gymikmh";
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
