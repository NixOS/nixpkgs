{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, cmake
, wrapGAppsHook
, glib
, gsound
, libgudev
, json-glib
, vala
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "feedbackd";
  version = "0.0.0+git20200527";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wbkzxnqjydfgjvp7vz4ghczcz740zcb1yn90cb6gb5md4n6qx2y";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    gsound
    libgudev
    json-glib
  ];

  meta = with stdenv.lib; {
    description = "A daemon to provide haptic (and later more) feedback on events";
    homepage = "https://source.puri.sm/Librem5/feedbackd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ masipcat ];
    platforms = platforms.linux;
  };
}
