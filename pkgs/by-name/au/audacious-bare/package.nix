{
  lib,
  stdenv,
  audacious-plugins,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  qt6,
  withPlugins ? false,
}:

stdenv.mkDerivation rec {
  pname = "audacious";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "audacious-media-player";
    repo = "audacious";
    rev = "${pname}-${version}";
    hash = "sha256-Vh39uY15Pj2TbPk8gU55YykhFf5ytSUxN2gJ0VlC3tQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  mesonFlags = [
    "-Dgtk=false"
    "-Dbuildstamp=NixOS"
  ];

  postInstall = lib.optionalString withPlugins ''
    ln -s ${audacious-plugins}/lib/audacious $out/lib
    ln -s ${audacious-plugins}/share/audacious/Skins $out/share/audacious/
  '';

  meta = with lib; {
    description = "Lightweight and versatile audio player";
    homepage = "https://audacious-media-player.org";
    downloadPage = "https://github.com/audacious-media-player/audacious";
    mainProgram = "audacious";
    maintainers = with maintainers; [
      ramkromberg
      ttuegel
      thiagokokada
    ];
    platforms = platforms.linux;
    license = with licenses; [
      bsd2
      bsd3 # https://github.com/audacious-media-player/audacious/blob/master/COPYING
      gpl2
      gpl3
      lgpl2Plus # http://redmine.audacious-media-player.org/issues/46
    ];
  };
}
