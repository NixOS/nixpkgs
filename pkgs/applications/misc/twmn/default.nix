{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "twmn";
  version = "2025_10_23";

  src = fetchFromGitHub {
    owner = "sboli";
    repo = "twmn";
    tag = version;
    hash = "sha256-/yQtwoolGhtn19I+vus27OjaZgXXfhnWKQi+rUMozCY=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    boost
  ];

  postPatch = ''
    sed -i s/-Werror// twmnd/twmnd.pro
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp bin/* "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "Notification system for tiling window managers";
    homepage = "https://github.com/sboli/twmn";
    platforms = with lib.platforms; linux;
    maintainers = [ lib.maintainers.matejc ];
    license = lib.licenses.lgpl3;
  };
}
