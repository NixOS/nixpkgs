{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  libdivsufsort,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "flips";
  version = "unstable-2023-03-15";

  src = fetchFromGitHub {
    owner = "Alcaro";
    repo = "Flips";
    rev = "fdd5c6e34285beef5b9be759c9b91390df486c66";
    hash = "sha256-uuHgpt7aWqiMTUILm5tAEGGeZrls3g/DdylYQgsfpTw=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
    libdivsufsort
  ];
  patches = [ ./use-system-libdivsufsort.patch ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildPhase = ''
    runHook preBuild
    ./make.sh
    runHook postBuild
  '';

  meta = with lib; {
    description = "Patcher for IPS and BPS files";
    homepage = "https://github.com/Alcaro/Flips";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = platforms.linux;
    mainProgram = "flips";
  };
}
