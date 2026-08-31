{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  unzip,
  pkg-config,
  SDL,
  SDL_mixer,
  bulletml,
  makeWrapper,
}:

let
  debianVersion = "0.51a-13";
  debianPatch =
    patchname: extraArgs:
    fetchpatch (
      {
        name = "${patchname}.patch";
        url = "https://sources.debian.org/data/main/n/noiz2sa/${debianVersion}/debian/patches/${patchname}.patch";
      }
      // extraArgs
    );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "noiz2sa";
  version = "0.52";

  src = fetchurl {
    url = "https://abagames.sakura.ne.jp/windows/noiz2sa${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.zip";
    hash = "sha256-lZdZFAqAs8xxiUahGLaCX9UhjzGGE4pRp4GcX7k43/w=";
  };

  patches = [
    (debianPatch "build" {
      excludes = [
        "src/bulletml/*"
        "src/Makefile"
      ];
      hash = "sha256-EfKX0npjAE2gzdpdth2V0Qamj1BcxyB40IsxNq6KxaQ=";
    })
    (debianPatch "deg-out-of-range" {
      hash = "sha256-4imehhIHC2E9XFzepxdyPE8Ga5DIAb94PmReRNOeEz4=";
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    unzip
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    SDL
    SDL_mixer
    bulletml
  ];

  sourceRoot = "noiz2sa";

  buildPhase = ''
    runHook preBuild

    pushd src

    $CC -c $(pkg-config --cflags sdl SDL_mixer) -O3 *.c
    $CXX -c $(pkg-config --cflags sdl SDL_mixer) -O3 *.cc \
      -I${bulletml}/include
    $CC -o noiz2sa *.o \
      $(pkg-config --libs sdl SDL_mixer) \
      -L${bulletml}/lib -lbulletml -lstdc++ -lm

    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/games/noiz2sa
    install -m755 src/noiz2sa $out/share/games/noiz2sa/noiz2sa-unwrapped
    cp -r boss middle zako images sounds $out/share/games/noiz2sa/

    makeWrapper $out/share/games/noiz2sa/noiz2sa-unwrapped $out/bin/noiz2sa \
      --chdir "$out/share/games/noiz2sa"

    runHook postInstall
  '';

  meta = {
    description = "Abstract shoot-em-up game";
    homepage = "http://www.asahi-net.or.jp/~cs8k-cyu/windows/noiz2sa_e.html";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ rattboi ];
    platforms = lib.platforms.linux;
    mainProgram = "noiz2sa";
  };
})
