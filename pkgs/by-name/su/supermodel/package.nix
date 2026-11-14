{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  SDL2,

  # buildInputs
  libGL,
  libGLU,
  libx11,
  SDL2_net,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "supermodel";
  version = "0.3a-20260528-git-77d28ee";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "trzy";
    repo = "Supermodel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uH4QGaS6Jm4c6L8Tu42qJvKHZPDNEkWXBG0tjMJ0Cvw=";
  };

  nativeBuildInputs = [
    SDL2 # sdl2-config
  ];

  buildInputs = [
    libGL
    libGLU
    libx11
    SDL2_net
    zlib
  ];

  makefile = "Makefiles/Makefile.UNIX";

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
    longDescription = ''
      Supermodel requires specific files to be present in the $HOME directory of
      the user running the emulator. To ensure these files are present, move the
      configuration and assets as follows:

      <code>cp $out/share/supermodel/Config/Supermodel.ini ~/.config/supermodel/Config/Supermodel.ini</code>
      <code>cp -r $out/share/supermodel/Assets/* ~/.local/share/supermodel/Assets/</code>

      Then the emulator can be started with:
      <code>supermodel -game-xml-file=$out/share/supermodel/Config/Games.xml /path/to/romset</code>.
    '';
    homepage = "https://github.com/trzy/supermodel";
    downloadPage = "https://github.com/trzy/Supermodel/releases";
    changelog = "https://github.com/trzy/Supermodel/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus

      # Src/Pkgs/wglew.h
      bsd3

      # Src/Pkgs/imgui
      mit

      # Src/Pkgs/unzip.c
      info-zip
    ];
    maintainers = with lib.maintainers; [ msanft ];
    mainProgram = "supermodel";
    platforms = lib.platforms.linux;
  };
})
