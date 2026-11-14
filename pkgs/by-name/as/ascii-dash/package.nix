{
  lib,
  stdenv,
  fetchzip,
  cmake,
  makeWrapper,
  ncurses,
  SDL2,
  SDL2_mixer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ascii-dash";
  version = "1.3";

  src = fetchzip {
    url = "mirror://sourceforge/ascii-dash/ASCII-DASH-${finalAttrs.version}.zip";
    hash = "sha256-PoMYWQjvzsoI/CEm3CIkOE5TK3iCnpM2/uM4pGGdvL0=";
  };

  strictDeps = true;

  sourceRoot = "source/ASCII-DASH-${finalAttrs.version}";

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    ncurses
    SDL2
    SDL2_mixer
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck

    ./main --help | grep -Fq "usage:"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -d "$out/libexec/ascii-dash" "$out/share/ascii-dash"
    install -Dm755 main "$out/libexec/ascii-dash/ascii-dash"
    cp -a ../data "$out/share/ascii-dash/"
    cp -a ../sounds "$out/share/ascii-dash/"

    install -Dm644 ../README.md ../README.txt -t "$out/share/doc/ascii-dash"
    install -Dm644 ../COPYING -t "$out/share/licenses/ascii-dash"

    makeWrapper "$out/libexec/ascii-dash/ascii-dash" "$out/bin/ascii-dash" \
      --chdir "$out/share/ascii-dash"

    runHook postInstall
  '';

  meta = {
    description = "Remake of BOULDER DASH with NCurses";
    homepage = "https://sourceforge.net/projects/ascii-dash/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Zaczero ];
    mainProgram = "ascii-dash";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
