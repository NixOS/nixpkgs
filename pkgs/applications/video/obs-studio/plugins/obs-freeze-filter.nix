{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-freeze-filter";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-freeze-filter";
    rev = finalAttrs.version;
    hash = "sha256-1x2r3Hdvx3y8reTWNUOgMqnOPaaUB75ibL6RuwEubQQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
    qtbase
  ];

  postInstall = ''
    rm -rf "$out/share"
    mkdir -p "$out/share/obs"
    mv "$out/data/obs-plugins" "$out/share/obs"
    rm -rf "$out/obs-plugins" "$out/data"
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Plugin for OBS Studio to freeze a source using a filter";
    homepage = "https://github.com/exeldro/obs-freeze-filter";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pschmitt ];
  };
})
