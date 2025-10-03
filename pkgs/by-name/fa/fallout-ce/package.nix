{
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  fpattern,
  lib,
  SDL2,
  stdenv,
  writeShellScript,
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
      echo "Please reference the installation instructions at https://github.com/alexbatalov/fallout1-ce"
    fi

    if [ $fault -ne 0 ]; then
      exit $fault;
    fi

    exec @out@/libexec/fallout-ce "$@"
  '';
in

stdenv.mkDerivation rec {
  pname = "fallout-ce";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "alexbatalov";
    repo = "fallout1-ce";
    rev = "v${version}";
    hash = "sha256-ZiBoF3SL00sN0QrD3fkWG9SAknumOvzRB1oQJff6ITA=";
  };

  patches = [
    # Fix case-sensitive filesystems issue when save/load games
    (fetchpatch2 {
      url = "https://github.com/alexbatalov/fallout1-ce/commit/aa3c5c1e3e3f9642d536406b2d8d6b362c9e402f.patch";
      sha256 = "sha256-quFRbKMS2pNDCNTWc1ZoB3jnB5qzw0b+2OeJUi8IPBc=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ];
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
      license = licenses.sustainableUse;
      description = "Fully working re-implementation of Fallout, with the same original gameplay, engine bugfixes, and some quality of life improvements";
      homepage = "https://github.com/alexbatalov/fallout1-ce";
      maintainers = with maintainers; [
        hughobrien
        iedame
      ];
      platforms = platforms.linux;
    };
}

