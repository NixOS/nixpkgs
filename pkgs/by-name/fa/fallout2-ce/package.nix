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

    if [ ! -d "data/sound/music" ]; then
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

stdenv.mkDerivation rec {
  pname = "fallout2-ce";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "alexbatalov";
    repo = "fallout2-ce";
    rev = "v${version}";
    hash = "sha256-r1pnmyuo3uw2R0x9vGScSHIVNA6t+txxABzgHkUEY5U=";
  };

  patches = [
    # Fix case-sensitive filesystems issue when save/load games
    (fetchpatch2 {
      url = "https://github.com/alexbatalov/fallout2-ce/commit/d843a662b3ceaf01ac363e9abb4bfceb8b805c36.patch";
      sha256 = "sha256-r4sfl1JolWRNd2xcf4BMCxZw3tbN21UJW4TdyIbQzgs=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
    zlib
  ];
  hardeningDisable = [ "format" ];
  cmakeBuildType = "RelWithDebInfo";

  postPatch = ''
    substituteInPlace third_party/fpattern/CMakeLists.txt \
      --replace "FetchContent_Populate" "#FetchContent_Populate" \
      --replace "{fpattern_SOURCE_DIR}" "${fpattern}/include" \
      --replace "$/nix/" "/nix/"
  '';

  installPhase = ''
    runHook preInstall

    install -D ${pname} $out/libexec/${pname}
    install -D ${launcher} $out/bin/${pname}
    substituteInPlace $out/bin/${pname} --subst-var out

    runHook postInstall
  '';

  meta =
    with lib;
    {
      description = "Fully working re-implementation of Fallout 2, with the same original gameplay, engine bugfixes, and some quality of life improvements";
      homepage = "https://github.com/alexbatalov/fallout2-ce";
      license = licenses.sustainableUse;
      maintainers = with maintainers; [
        hughobrien
        iedame
      ];
      platforms = platforms.linux;
    };
}
