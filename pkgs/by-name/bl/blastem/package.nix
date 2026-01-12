{
  lib,
  stdenv,
  fetchhg,
  pkg-config,
  makeBinaryWrapper,
  SDL2,
  glew,
  gtk3,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blastem";
  version = "0.6.2-unstable-2024-08-14";

  src = fetchhg {
    url = "https://www.retrodev.com/repos/blastem";
    rev = "aa888682faa0";
    hash = "sha256-0xw9O0o1pkJiXHyZer4nMJeLlRXS3Z4YYoLgfkrz3Yo=";
  };

  # will probably be fixed in https://github.com/NixOS/nixpkgs/pull/302481
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
        --replace-fail "-flto" ""
  '';

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    gtk3
    SDL2
    glew
  ];

  # Note: menu.bin cannot be generated yet, because it would
  # need the `vasmm68k_mot` executable (part of vbcc for amigaos68k
  # Luckily, menu.bin doesn't need to be present for the emulator to function

  makeFlags = [ "HOST_ZLIB=1" ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";

  installPhase = ''
    runHook preInstall

    # not sure if any executable other than blastem is really needed here
    install -Dm755 blastem dis zdis termhelper -t $out/share/blastem
    install -Dm644 gamecontrollerdb.txt default.cfg rom.db -t $out/share/blastem
    cp -r shaders $out/share/blastem/shaders

    # wrapping instead of sym-linking makes sure argv0 stays at the original location
    makeWrapper $out/share/blastem/blastem $out/bin/blastem

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "blastem -v";
    version = "0.6.3-pre"; # remove line when moving to a stable version
  };

  meta = {
    description = "Fast and accurate Genesis emulator";
    homepage = "https://www.retrodev.com/blastem/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "blastem";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
})
