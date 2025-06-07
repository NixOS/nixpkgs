{
  lib,
  stdenv,
  fetchFromSourcehut,
  sdl3,
  fluidsynth,
  libGL,
  libpng,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doom64ex-minus";
  version = "1";

  src = fetchFromSourcehut {
    owner = "~marcin-serwin";
    repo = "Doom64EX-Minus";
    rev = "z${finalAttrs.version}";
    hash = "sha256-V0+p+UGSMxJSVX22VL9e8MNHlXDRrhdoEND+Dfv04HI=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fluidsynth
    libGL
    libpng
    sdl3
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { LDFLAGS = "-framework OpenGL"; };
  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    buildFlagsArray+=('LIBS=sdl3 fluidsynth libpng')
  '';

  meta = {
    description = "Improved, modern version of Doom64EX";
    homepage = "https://git.sr.ht/~marcin-serwin/Doom64EX-Minus";
    license = with lib.licenses; [
      gpl2Plus
      unfree
    ];
    longDescription = ''
      You will need DOOM64.WAD from Nightdive Studios'
      DOOM 64 Remastered release. To extract it from the GOG
      installer, run:
      ``` bash
      nix-shell -p innoextract.out --run \
      'innoextract -g /path/to/installer.exe \
      -I DOOM64.WAD -d ~/.local/share/doom64ex-minus'
      ```
    '';
    maintainers = with lib.maintainers; [
      keenanweaver
      marcin-serwin
    ];
    mainProgram = "doom64ex-minus";
    platforms = lib.platforms.unix;
  };
})
