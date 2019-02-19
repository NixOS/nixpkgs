{ stdenv, fetchFromGitHub
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk_pixbuf
, wlroots, wayland-protocols
, buildDocs ? true
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "sway";
  version = "1.0-rc3";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "1ixwc1bg725x68qr84s8a5i4rlzc4svc52jgdw1yl5bgr6l1k5zc";
  };

  postPatch = ''
    sed -iE "s/version: '1.0',/version: '${version}',/" meson.build
  '';

  nativeBuildInputs = [
    pkgconfig meson ninja
  ] ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk_pixbuf
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Dxwayland=enabled" "-Dgdk-pixbuf=enabled"
    "-Dtray=enabled"
  ] ++ stdenv.lib.optional buildDocs "-Dman-pages=enabled";

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
