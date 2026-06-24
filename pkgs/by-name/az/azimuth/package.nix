{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  pkg-config,
  libGL,
  which,
  makeBinaryWrapper,
  icnsify,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "azimuth";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "mdsteele";
    repo = "azimuth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5Ahetw/zOXDrEiR1umQNF6i3yeawavoLceiU+xD//g=";
  };

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
    which
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    icnsify
  ];

  buildInputs = [
    SDL2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
  ];

  makeFlags = [ "BUILDTYPE=release" ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs src/azimuth/system/generate_blob_index.sh

    # Modern Clang over-erroring measures
    substituteInPlace Makefile \
      --replace-fail \
        '-Werror' \
        '-Werror -Wno-uninitialized-const-pointer -Wno-default-const-init-var-unsafe'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # iconutil is not available in the build sandbox
    substituteInPlace Makefile \
      --replace-fail \
        'iconutil -c icns $(OUTDIR)/icon.iconset -o $@ 2> /dev/null' \
        'icnsify $(OUTDIR)/icon.iconset/icon_128x128.png -o $@'
  '';

  doCheck = true;
  checkTarget = "test";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 out/release/host/bin/azimuth $out/bin/
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -R out/release/host/Azimuth.app $out/Applications/
  ''
  + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeBinaryWrapper "$out/Applications/Azimuth.app/Contents/MacOS/Azimuth" \
      "$out/bin/azimuth"
  '';

  meta = {
    description = "Metroidvania game with vector graphics, inspired by Super Metroid and Star Control II";
    longDescription = ''
      Azimuth is a metroidvania game, and something of an homage to the previous
      greats of the genre (Super Metroid in particular). You will need to pilot
      your ship, explore the inside of the planet, fight enemies, overcome
      obstacles, and uncover the storyline piece by piece. Azimuth features a
      huge game world to explore, lots of little puzzles to solve, dozens of
      weapons and upgrades to find and use, and a wide variety of enemies and
      bosses to tangle with.
    '';
    homepage = "https://mdsteele.games/azimuth/";
    changelog = "https://github.com/mdsteele/azimuth/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      philocalyst
      marius851000
    ];
    mainProgram = "azimuth";
    platforms = lib.platforms.unix;
  };

})
