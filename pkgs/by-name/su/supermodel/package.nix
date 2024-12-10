{
  fetchFromGitHub,
  lib,
  libGLU,
  SDL2,
  SDL2_net,
  stdenv,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "supermodel";
  version = "0-unstable-2024-04-05";

  src = fetchFromGitHub {
    owner = "trzy";
    repo = "supermodel";
    rev = "250f84e78eba381adf8cd731ce20b1b9be43c8c8";
    hash = "sha256-3sDtNMW5R5Eq9GXJzKs0mQdiLUIWl6+4+rzKg8xpqEY=";
  };

  buildInputs = [
    libGLU
    SDL2
    SDL2_net
    zlib
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  makefile = "Makefiles/Makefile.UNIX";

  makeFlags = [ "NET_BOARD=1" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/supermodel
    cp bin/* $out/bin
    cp -r Config Assets $out/share/supermodel

    runHook postInstall
  '';

  meta = {
    description = "A Sega Model 3 Arcade Emulator";
    homepage = "https://github.com/trzy/supermodel";
    license = lib.licenses.gpl3;
    longDescription = ''
      Supermodel requires specific files to be present in the $HOME directory of
      the user running the emulator. To ensure these files are present, move the
      configuration and assets as follows:

      <code>cp $out/share/supermodel/Config/Supermodel.ini ~/.config/supermodel/Config/Supermodel.ini</code>
      <code>cp -r $out/share/supermodel/Assets/* ~/.local/share/supermodel/Assets/</code>

      Then the emulator can be started with:
      <code>supermodel -game-xml-file=$out/share/supermodel/Config/Games.xml /path/to/romset</code>.
    '';
    mainProgram = "supermodel";
    maintainers = with lib.maintainers; [ msanft ];
    platforms = lib.platforms.linux;
  };
}
