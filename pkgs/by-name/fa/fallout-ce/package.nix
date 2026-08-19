{
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  fpattern,
  lib,
  SDL2,
  stdenv,
  writeShellScript,
  nix-update-script,
}:

let
  launcher = writeShellScript "fallout-ce" ''
    set -eu
    assetDir="''${XDG_DATA_HOME:-$HOME/.local/share}/fallout-ce"
    [ -d "$assetDir" ] || mkdir -p "$assetDir"
    cd "$assetDir"

    notice=0 fault=0
    requiredFiles=(master.dat critter.dat)
    for f in "''${requiredFiles[@]}"; do
      if [ ! -f "$f" ] && [ ! -f "$(tr '[:lower:]' '[:upper:]' <<< "$f")" ]; then
        echo "Required file $f not found in $PWD"
        notice=1 fault=1
      fi
    done

    if [ ! -d "data/sound/music" ] && [ ! -d "DATA/SOUND/MUSIC" ]; then
      echo "data/sound/music directory not found in $PWD. This may prevent in-game music from functioning."
      notice=1
    fi

    if [ $notice -ne 0 ]; then
      echo "Please reference the installation instructions at https://github.com/alexbatalov/fallout1-ce"
    fi

    if [ $fault -ne 0 ]; then
      exit $fault;
    fi

    exec @out@/libexec/fallout-ce "$@"
  '';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "fallout-ce";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "alexbatalov";
    repo = "fallout1-ce";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZiBoF3SL00sN0QrD3fkWG9SAknumOvzRB1oQJff6ITA=";
  };

  patches = [
    # Fix case-sensitive filesystems issue when save/load games
    (fetchpatch2 {
      url = "https://github.com/alexbatalov/fallout1-ce/commit/fbd25f00e9ccfb5391e394272d536206bb86678b.patch?full_index=1";
      sha256 = "sha256-MylI1DZwaANuScyRJ7fXch3aym8n6BDRhccAXAyvU70=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ SDL2 ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace third_party/fpattern/CMakeLists.txt \
      --replace-fail "FetchContent_Populate" "#FetchContent_Populate" \
      --replace-fail "\''${fpattern_SOURCE_DIR}" "${fpattern}/include"
  '';

  installPhase = ''
    runHook preInstall

    install -D fallout-ce $out/libexec/fallout-ce
    install -D ${launcher} $out/bin/fallout-ce
    substituteInPlace $out/bin/fallout-ce --subst-var out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fallout for modern operating systems";
    longDescription = ''
      Fully working re-implementation of Fallout, with the same original gameplay, engine bugfixes, and some quality of life improvements.
      You must own the game and copy the files to the specified folder to play.
    '';
    homepage = "https://github.com/alexbatalov/fallout1-ce";
    license = lib.licenses.sustainableUse;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.linux;
    mainProgram = "fallout-ce";
  };
})
