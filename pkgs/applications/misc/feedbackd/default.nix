{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
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
  version = "v0.0.0+git20200420";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "fd5e63c0a0c1b9296249d517c6849402a3a3ca10";
    sha256 = "0glzc284wbvwvax52lp6sqr4whhpbqrkn8isidlqz1yrag3phfv9";
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gsound
    libgudev
    json-glib
    vala
    gobject-introspection
  ];

  configurePhase = "meson build --prefix=$out";
  buildPhase = "ninja -C build";
  installPhase = "ninja -C build install";

  meta = with stdenv.lib; {
    description = "A daemon to provide haptic (and later more) feedback on events";
    homepage = https://source.puri.sm/Librem5/feedbackd;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ masipcat ];
    platforms = platforms.linux;
  };
}
