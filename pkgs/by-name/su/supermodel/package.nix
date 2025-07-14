{
  fetchFromGitHub,
  lib,
  libGLU,
  SDL2,
  SDL2_net,
  xorg,
  stdenv,
  zlib,
}:

stdenv.mkDerivation {
  pname = "supermodel";
  version = "0-unstable-2025-04-17";

  src = fetchFromGitHub {
    owner = "trzy";
    repo = "supermodel";
    rev = "2272893a0511c0b3b50f6dda64addb7014717dd3";
    hash = "sha256-3FdLBGxmi4Xj7ao2nvjLleJSTXvKQrhUWvnQr8DK/RY=";
  };

  buildInputs = [
    libGLU
    SDL2
    SDL2_net
    xorg.libX11
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
    description = "Sega Model 3 Arcade Emulator";
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
