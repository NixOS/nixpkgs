{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  pkg-config,
  glib,
  zlib,
  libpng,
  cmake,
  python3,
  python3Packages,

  # optionally specify a derivation containing the lens data as generated from the `generate_db.py` script
  lensfunDatabases ? null,
}:

let
  version = "0.3.4";
  pname = "lensfun";

  lensData =
    if lensfunDatabases != null then
      lensfunDatabases
    else
      # fetch a more recent version of the lens database
      stdenvNoCC.mkDerivation {
        name = "lensfun-databases";

        src = fetchFromGitHub {
          owner = "lensfun";
          repo = "lensfun";
          rev = "201da1a7433626a2a1ecd67e1f21a42fb17aa4a5";
          sha256 = "sha256-64ZcupHA4oClPRCnG8KofGC46M/mZFermugzQ15B6k4=";

          leaveDotGit = true;
          # generate timestamp based on the most recent commit
          postFetch = ''
            cd $out
            git log -1 --format=%at > $out/timestamp.txt
            rm -R .git
          '';
        };

        nativeBuildInputs = [
          python3
          python3Packages.setuptools
          python3Packages.lxml
        ];

        # generates versioned tarballs of lens data
        # patch applied so that we read the previously generated `timestamp.txt` instead
        # of trying to read from `.git` (which is deleted during `postFetch`)
        buildPhase = ''
          substituteInPlace tools/update_database/generate_db.py \
            --replace-fail '"git", "log", "-1", "--format=%ad", "--date=raw", "--", "*.xml"' '"cat", "timestamp.txt"'
          python3 tools/update_database/generate_db.py --input data/db --output $out
          cp timestamp.txt $out/timestamp.txt
        '';
      };

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "v${version}";
    sha256 = "sha256-FyYilIz9ssSHG6S02Z2bXy7fjSY51+SWW3v8bm7sLvY=";
  };

  # replace database with a more recent snapshot
  # the master branch uses version 2 profiles, while this version requires version 1 profiles
  # also copies in the required `timestamp.txt` file
  prePatch = ''
    rm -R data/db
    mkdir -p data/db
    tar xvfj ${lensData}/version_1.tar.bz2 -C data/db
    cp ${lensData}/timestamp.txt data/db/timestamp.txt
  ''
  # Backport CMake 4 support
  # This is already on master, but not yet in a stable release:
  # https://github.com/lensfun/lensfun/issues/2520
  # https://github.com/lensfun/lensfun/commit/011de2e85813ff496a85404b30891352555de077
  + ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'CMAKE_MINIMUM_REQUIRED(VERSION 2.8.12 FATAL_ERROR )' \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.12 FATAL_ERROR)'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    zlib
    libpng
  ];

  cmakeFlags = [ "-DINSTALL_HELPER_SCRIPTS=OFF" ];

  meta = {
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      flokli
      paperdigits
    ];
    license = lib.licenses.lgpl3;
    description = "Opensource database of photographic lenses and their characteristics";
    homepage = "https://lensfun.github.io";
  };
}
