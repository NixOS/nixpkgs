{ stdenv, fetchFromGitHub
, meson, ninja
, pkgconfig, asciidoc, libxslt, docbook_xsl
, wayland, wlc, libxkbcommon, pcre, json_c, dbus
, pango, cairo, libinput, libcap, pam, gdk_pixbuf, libpthreadstubs
, libXdmcp, wlroots, wayland-protocols
, buildDocs ? true
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "sway-beta";
  version = "1.0-beta.1";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "0h9kgrg9mh2acks63z72bw3lwff32pf2nb4i7i5xhd9i6l4gfnqa";
  };

  nativeBuildInputs = [
    pkgconfig meson ninja
  ] ++ stdenv.lib.optional buildDocs [ asciidoc libxslt docbook_xsl ];

  buildInputs = [
    wayland wlc libxkbcommon pcre json_c dbus
    pango cairo libinput libcap pam gdk_pixbuf libpthreadstubs
    libXdmcp wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = "-Dsway-version=${version}";

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = http://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
