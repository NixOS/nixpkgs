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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-freeze-filter";
    rev = finalAttrs.version;
    sha256 = "sha256-CaHBTfdk8VFjmiclG61elj35glQafgz5B4ENo+7J35o=";
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

  meta = with lib; {
    description = "Plugin for OBS Studio to freeze a source using a filter";
    homepage = "https://github.com/exeldro/obs-freeze-filter";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pschmitt ];
  };
})
