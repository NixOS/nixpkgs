{
  appimageTools,
  lib,
  fetchurl,
}:
let
  pname = "fspy";
  version = "1.0.3";

  src = fetchurl {
    url = "https://github.com/stuffmatic/fSpy/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    sha256 = "sha256-L+qsSExuEkzZkjnV/J6rrZ3BXqWQd+IfsN6a3kvQF3A=";
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  meta = {
    description = "Cross platform app for quick and easy still image camera matching";
    license = lib.licenses.gpl3;
    homepage = "https://fspy.io/";
    knownVulnerabilities = [ "Vendors Electron 2.0 (end-of-life)" ];
    maintainers = with lib.maintainers; [ polygon ];
    platforms = lib.platforms.linux;
    mainProgram = "fspy";
  };
}
