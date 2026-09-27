{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wrapGAppsHook4,
  librnd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcb-rnd";
  version = "3.1.7";

  # Alternative: https://salsa.debian.org/electronics-team/ringdove-eda/pcb-rnd
  src = fetchurl {
    url = "http://repo.hu/projects/pcb-rnd/releases/pcb-rnd-${finalAttrs.version}.tar.gz";
    hash = "sha256-IUV2FbJwjIEBNIH0f16VKWqRoMAiYe7OeXpSHG3+KT0=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    librnd
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/scalable/apps
    ln -s $out/share/doc/pcb-rnd/resources/logo.svg $out/share/icons/hicolor/scalable/apps/pcb-rnd.svg
    install -Dm644 doc/resources/pcb-rnd.desktop -t $out/share/applications
  '';

  env = {
    LIBRND_PREFIX = librnd.outPath;
  };

  meta = {
    description = "Flexible, modular Printed Circuit Board editor";
    homepage = "https://repo.hu/projects/pcb-rnd";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    teams = [ lib.teams.ngi ];
    mainProgram = "pcb-rnd";
    platforms = lib.platforms.unix;
  };
})
