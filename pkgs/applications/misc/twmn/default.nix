{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qtbase,
  qmake,
  pkg-config,
  boost,
}:

mkDerivation rec {
  pname = "twmn";
  version = "2025_03_06";

  src = fetchFromGitHub {
    owner = "sboli";
    repo = "twmn";
    tag = version;
    hash = "sha256-JQhONBcTJUzsKJY6YstC6HB4d/t8vf155/lN4UUv4l4=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
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
