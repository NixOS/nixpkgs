{ stdenv, fetchFromGitHub, fetchpatch
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
  version = "1.0";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "09cndc2nl39d3l7g5634xp0pxcz60pvc5277mfw89r22mh0j78rx";
  };

  # TODO: The following patch introduced a compiler warning which leads to a
  # build failure (we'll revert it for now as this patch is not supposed to
  # change any functionality):
  patch-remove-unused-functions = fetchpatch {
    url = "https://github.com/swaywm/sway/commit/2b70e8518b7327d29eec4f9593e9b8f4238cebfe.patch";
    sha256 = "1bq1i8dzxwckahzna6s9swvhpj1c1ics14pc1f1jcxwya50lk1rz";
  };

  postPatch = ''
    patch -p1 --reverse < ${patch-remove-unused-functions}
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
    "-Dxwayland=enabled" "-Dgdk-pixbuf=enabled" "-Dtray=enabled"
  ] ++ stdenv.lib.optional buildDocs "-Dman-pages=enabled";

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
