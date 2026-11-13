{
  lib,
  stdenv,
  fetchhg,

  makeBinaryWrapper,
  pkg-config,
  python3,

  glew,
  gtk3,
  SDL2,

  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blastem";
  version = "1.0.0";

  src = fetchhg {
    url = "https://www.retrodev.com/repos/blastem";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Fs78GFmvndJz+Ngpzw3bRyL8IX8UUJBAbV3TcNbHJHA=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/bin/echo' 'echo'
    patchShebangs cpu_dsl.py
  '';

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    gtk3
    glew
    SDL2
  ];

  # Note: menu.bin cannot be generated yet, because it would
  # need the `vasmm68k_mot` executable (part of vbcc for amigaos68k)
  # Luckily, menu.bin doesn't need to be present for the emulator to function

  makeFlags = [ "HOST_ZLIB=1" ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";

  installPhase = ''
    runHook preInstall

    # not sure if any executable other than blastem is really needed here
    install -Dm755 blastem dis zdis upddis sh2dis termhelper -t $out/share/blastem
    install -Dm644 gamecontrollerdb.txt default.cfg rom.db -t $out/share/blastem
    cp -r shaders $out/share/blastem/shaders

    # wrapping instead of sym-linking makes sure argv0 stays at the original location
    makeWrapper $out/share/blastem/blastem $out/bin/blastem

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "blastem -v";
  };

  meta = {
    description = "Fast and accurate emulator for Sega's 16-bit and 8-bit consoles";
    longDescription = ''
      BlastEm is a free and Open Source emulator for Sega's 16-bit and 8-bit consoles.
      It's fast enough for your old PC and accurate enough for the most demanding demos.
      While BlastEm's primary focus is the Genesis (known as the Megadrive outside North America),
      it also supports the Sega CD, 32X, Master System, Game Gear, SG-1000, SC-3000, Sega Pico and Yamaha Copera.
    '';
    homepage = "https://www.retrodev.com/blastem/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "blastem";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
