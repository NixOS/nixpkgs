{ stdenv
, lib
, fetchFromSourcehut
, wrapGAppsHook
, pkg-config
, cmake
, meson
, ninja
, gtk3
, gtk-layer-shell
, json_c
, librsvg
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "gtkgreet";
  version = "0.7";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "ms+2FdtzzNlmlzNxFhu4cpX5H+5H+9ZOtZ0p8uVA3lo=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    json_c
    scdoc
    librsvg
  ];

  mesonFlags = [
    "-Dlayershell=enabled"
  ];

  # G_APPLICATION_FLAGS_NONE is deprecated in GLib 2.73.3+.
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  meta = with lib; {
    description = "GTK based greeter for greetd, to be run under cage or similar";
    homepage = "https://git.sr.ht/~kennylevinsen/gtkgreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
    mainProgram = "gtkgreet";
  };
}
