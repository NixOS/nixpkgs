{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asio,
  obs-studio,
  qtbase,
  websocketpp,
}:

stdenv.mkDerivation rec {
  pname = "obs-websocket";
  version = "4.9.1-compat";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-websocket";
    rev = version;
    sha256 = "sha256-cHsJxoQjwbWLxiHgIa3Es0mu62vyLCAd1wULeZqZsJM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    asio
    obs-studio
    qtbase
    websocketpp
  ];

  dontWrapQtApps = true;

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  meta = with lib; {
    description = "Legacy websocket 4.9.1 protocol support for OBS Studio 28 or above";
    homepage = "https://github.com/obsproject/obs-websocket";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
