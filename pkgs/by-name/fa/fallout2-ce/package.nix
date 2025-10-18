{
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  fpattern,
  lib,
  SDL2,
  stdenv,
  writeShellScript,
  zlib,
  nix-update-script,
}:

let
  launcher = writeShellScript "fallout2-ce" ''
    set -eu
    assetDir="''${XDG_DATA_HOME:-$HOME/.local/share}/fallout2-ce"
    [ -d "$assetDir" ] || mkdir -p "$assetDir"
    cd "$assetDir"

    notice=0 fault=0
    requiredFiles=(master.dat critter.dat)
    for f in "''${requiredFiles[@]}"; do
      if [ ! -f "$f" ]; then
        echo "Required file $f not found in $PWD, note the files are case-sensitive"
        notice=1 fault=1
      fi
    done

    if [ ! -d "data/sound/music" ] && [ ! -d "sound/music" ]; then
      echo "data/sound/music directory not found in $PWD. This may prevent in-game music from functioning."
      notice=1
    fi

    if [ $notice -ne 0 ]; then
      echo "Please reference the installation instructions at https://github.com/alexbatalov/fallout2-ce"
    fi

    if [ $fault -ne 0 ]; then
      exit $fault;
    fi

    exec @out@/libexec/fallout2-ce "$@"
  '';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "fallout2-ce";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "alexbatalov";
    repo = "fallout2-ce";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r1pnmyuo3uw2R0x9vGScSHIVNA6t+txxABzgHkUEY5U=";
  };

  patches = [
    # Fix case-sensitive filesystems issue when save/load games
    (fetchpatch2 {
      url = "https://github.com/alexbatalov/fallout2-ce/commit/e770e64a48cd4d0a58a07f8db72839e4747e4c1e.patch?full_index=1";
      hash = "sha256-49N6uXwOBL/sE+f+W4nX6Gpwwpmbgvy38B1NjECiia0=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    SDL2
    zlib
  ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace third_party/fpattern/CMakeLists.txt \
      --replace-fail "FetchContent_Populate" "#FetchContent_Populate" \
      --replace-fail "\''${fpattern_SOURCE_DIR}" "${fpattern}/include"
  '';

  installPhase = ''
    runHook preInstall

    install -D fallout2-ce $out/libexec/fallout2-ce
    install -D ${launcher} $out/bin/fallout2-ce
    substituteInPlace $out/bin/fallout2-ce --subst-var out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fallout 2 for modern operating systems";
    longDescription = ''
      Fully working re-implementation of Fallout 2, with the same original gameplay, engine bugfixes, and some quality of life improvements.
      You must own the game and copy the files to the specified folder to play.
    '';
    homepage = "https://github.com/alexbatalov/fallout2-ce";
    license = lib.licenses.sustainableUse;
    maintainers = with lib.maintainers; [
      hughobrien
      iedame
    ];
    platforms = lib.platforms.linux;
    mainProgram = "fallout2-ce";
  };
})
