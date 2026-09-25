{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
  zlib,
  bzip2,
  xxd,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "doomseeker";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "DoomseekerTeam";
    repo = "Doomseeker";
    rev = version;
    hash = "sha256-oTWsGLtXqate1UuVM47mlPOqIVYLOHEp8utR07sOoE4=";
  };

  patches = [
    ./dont_update_gitinfo.patch
    ./add_gitinfo.patch
    ./fix_paths.patch
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    cmake
    qt5.qttools
    pkg-config
    xxd
  ];
  buildInputs = [
    qt5.qtbase
    qt5.qtmultimedia
    zlib
    bzip2
  ];

  hardeningDisable = lib.optional stdenv.hostPlatform.isDarwin "format";

  # Doomseeker looks for the engines in the program directory
  postInstall = ''
    mv $out/bin/* $out/lib/doomseeker/
    ln -s $out/lib/doomseeker/doomseeker $out/bin/
  '';

  meta = {
    homepage = "http://doomseeker.drdteam.org/";
    description = "Multiplayer server browser for many Doom source ports";
    mainProgram = "doomseeker";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    # The last successful Darwin Hydra build was in 2023
    broken = stdenv.hostPlatform.isDarwin;
  };
}
