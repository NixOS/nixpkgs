{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  pcre2,
  sqlite,
  readline,
  zlib,
  bzip2,
  autoconf,
  automake,
  curl,
  buildPackages,
  re2c,
  gpm,
  libarchive,
  nix-update-script,
  cargo,
  rustPlatform,
  rustc,
  libunistring,
  prqlSupport ? stdenv.hostPlatform == stdenv.buildPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lnav";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "tstack";
    repo = "lnav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XS3/km2sJwRnWloLKu9X9z07+qBFRfUsaRpZVYjoclI=";
  };

  patches = [
    # fixes lnav in tmux by patching vendored dependency notcurses
    # https://github.com/tstack/lnav/issues/1390
    # remove on next release
    (fetchpatch {
      url = "https://github.com/tstack/lnav/commit/5e0bfa483714f05397265a690960d23ae22e1838.patch";
      hash = "sha256-dArPJik9KVI0KQjGw8W11oqGrbsBCNOr93gaH3yDPpo=";
    })
  ];

  enableParallelBuilding = true;

  separateDebugInfo = true;

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    autoconf
    automake
    zlib
    curl.dev
    re2c
  ]
  ++ lib.optionals prqlSupport [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [
    bzip2
    pcre2
    readline
    sqlite
    curl
    libarchive
    libunistring
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gpm
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${finalAttrs.src}/src/third-party/prqlc-c";
    hash = "sha256-svi+C3ELw6Ly0mtji8xOv+DDqR0z5shFNazHa3kDQVg=";
  };

  cargoRoot = "src/third-party/prqlc-c";

  preConfigure = ''
    ./autogen.sh
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tstack/lnav";
    description = "Logfile Navigator";
    longDescription = ''
      The log file navigator, lnav, is an enhanced log file viewer that takes
      advantage of any semantic information that can be gleaned from the files
      being viewed, such as timestamps and log levels. Using this extra
      semantic information, lnav can do things like interleaving messages from
      different files, generate histograms of messages over time, and providing
      hotkeys for navigating through the file. It is hoped that these features
      will allow the user to quickly and efficiently zero in on problems.
    '';
    downloadPage = "https://github.com/tstack/lnav/releases";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      dochang
      symphorien
      pcasaretto
    ];
    platforms = lib.platforms.unix;
    mainProgram = "lnav";
  };
})
