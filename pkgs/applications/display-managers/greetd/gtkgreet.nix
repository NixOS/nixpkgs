{
  stdenv,
  lib,
  fetchFromSourcehut,
  wrapGAppsHook3,
  pkg-config,
  cmake,
  meson,
  ninja,
  gtk3,
  gtk-layer-shell,
  json_c,
  librsvg,
  scdoc,
}:

stdenv.mkDerivation rec {
  pname = "gtkgreet";
  version = "0.8";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "sha256-GKBYql0hzqB6uY87SsAqHwf3qLAr7xznMnAjRtP4HS8=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
    scdoc
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    json_c
    librsvg
  ];

  mesonFlags = [
    "-Dlayershell=enabled"
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "dependency('scdoc'," "dependency('scdoc', native:true,"
  '';

  # G_APPLICATION_FLAGS_NONE is deprecated in GLib 2.73.3+.
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  meta = with lib; {
    description = "GTK based greeter for greetd, to be run under cage or similar";
    homepage = "https://git.sr.ht/~kennylevinsen/gtkgreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "gtkgreet";
  };
}
