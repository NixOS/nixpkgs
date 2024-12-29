{
  lib,
  stdenv,
  fetchFromGitHub,
  pcre2,
  sqlite,
  ncurses,
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
  apple-sdk_11,
}:

stdenv.mkDerivation rec {
  pname = "lnav";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "tstack";
    repo = "lnav";
    rev = "v${version}";
    sha256 = "sha256-m0r7LAo9pYFpS+oimVCNCipojxPzMMsLLjhjkitEwow=";
  };

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
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];
  buildInputs =
    [
      bzip2
      ncurses
      pcre2
      readline
      sqlite
      curl
      libarchive
    ]
    ++ lib.optionals stdenv.isDarwin [
      apple-sdk_11
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      gpm
    ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${src}/src/third-party/prqlc-c";
    hash = "sha256-jfmr6EuNW2mEHTEVHn6YnBDMzKxKI097vEFHXC4NT2Y=";
  };

  cargoRoot = "src/third-party/prqlc-c";

  preConfigure = ''
    ./autogen.sh
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
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
    license = licenses.bsd2;
    maintainers = with maintainers; [
      dochang
      symphorien
      pcasaretto
    ];
    platforms = platforms.unix;
    mainProgram = "lnav";
  };

}
