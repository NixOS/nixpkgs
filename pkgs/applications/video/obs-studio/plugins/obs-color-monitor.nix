{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-color-monitor";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "norihiro";
    repo = "obs-color-monitor";
    tag = finalAttrs.version;
    hash = "sha256-4Dagga9BgW1Fiaxqs9QlyTax+SgFyTiNiU3yP2GjIDs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
    qtbase
  ];

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    mv $out/data $out/share/obs
    rm -rf $out/obs-plugins
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Color Monitor plugin for OBS Studio";
    homepage = "https://github.com/norihiro/obs-color-monitor";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hlad ];
  };
})
