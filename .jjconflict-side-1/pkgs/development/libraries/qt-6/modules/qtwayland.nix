{
  lib,
  qtModule,
  qtbase,
  qtdeclarative,
  wayland,
  wayland-scanner,
  pkg-config,
  libdrm,
}:

qtModule {
  pname = "qtwayland";
  # wayland-scanner needs to be propagated as both build
  # (for the wayland-scanner binary) and host (for the
  # actual wayland.xml protocol definition)
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    wayland-scanner
  ];
  propagatedNativeBuildInputs = [
    wayland
    wayland-scanner
  ];
  buildInputs = [
    wayland
    libdrm
  ];
  nativeBuildInputs = [ pkg-config ];

  # Replace vendored wayland.xml with our matching version
  # FIXME: remove when upstream updates past 1.23
  postPatch = ''
    cp ${wayland-scanner}/share/wayland/wayland.xml src/3rdparty/protocol/wayland/wayland.xml
  '';

  meta = {
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
