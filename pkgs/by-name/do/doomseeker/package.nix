{
  lib,
  stdenv,
  cmake,
  fetchFromBitbucket,
  pkg-config,
  zlib,
  bzip2,
  xxd,
  qt5,
}:

stdenv.mkDerivation {
  pname = "doomseeker";
  version = "2023-08-09";

  src = fetchFromBitbucket {
    owner = "Doomseeker";
    repo = "doomseeker";
    rev = "4cce0a37b134283ed38ee4814bb282773f9c2ed1";
    hash = "sha256-J7gesOo8NUPuVaU0o4rCGzLrqr3IIMAchulWZG3HTqg=";
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
