{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  gettext,
  glib,
  pkg-config,
  libdrm,
  libGL,
  atkmm,
  pcre,
  gtkmm4,
  pugixml,
  libgbm,
  pciutils,
}:

stdenv.mkDerivation rec {
  pname = "adriconf";
  version = "2.7.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "adriconf";
    tag = "v${version}";
    sha256 = "sha256-0XTsYeS4tNAnGhuJ81fmjHhFS6fVq1lirui5b+ojxTQ=";
  };

  nativeBuildInputs = [
    cmake
    gettext # msgfmt
    glib # glib-compile-resources
    pkg-config
  ];
  buildInputs = [
    libdrm
    libGL
    atkmm
    pcre
    gtkmm4
    pugixml
    libgbm
    pciutils
  ];

  # tries to download googletest
  cmakeFlags = [ "-DENABLE_UNIT_TESTS=off" ];

  postInstall = ''
    install -Dm444 ../flatpak/org.freedesktop.adriconf.metainfo.xml \
      -t $out/share/metainfo/
    install -Dm444 ../flatpak/org.freedesktop.adriconf.desktop \
      -t $out/share/applications/
    install -Dm444 ../flatpak/org.freedesktop.adriconf.png \
      -t $out/share/icons/hicolor/256x256/apps/
  '';

  meta = {
    homepage = "https://gitlab.freedesktop.org/mesa/adriconf/";
    changelog = "https://gitlab.freedesktop.org/mesa/adriconf/-/releases/v${version}";
    description = "GUI tool used to configure open source graphics drivers";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ muscaln ];
    platforms = lib.platforms.linux;
    mainProgram = "adriconf";
  };
}
