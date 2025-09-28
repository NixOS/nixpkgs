{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  libmpdclient,
  ncurses,
  pkg-config,
  readline,
  libiconv,
  icu,
  curl,
  autoconf,
  automake,
  libtool,
  outputsSupport ? true, # outputs screen
  visualizerSupport ? false,
  fftw, # visualizer screen
  clockSupport ? true, # clock screen
  taglibSupport ? true,
  taglib, # tag editor
}:

stdenv.mkDerivation rec {
  pname = "ncmpcpp";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "ncmpcpp";
    repo = "ncmpcpp";
    tag = version;
    hash = "sha256-w3deSy71SWWD2kZKREowZh3KMNCBfBJbrjM0vW4/GrI=";
  };

  enableParallelBuilding = true;

  strictDeps = true;

  configureFlags = [
    "BOOST_LIB_SUFFIX="
    (lib.enableFeature outputsSupport "outputs")
    (lib.enableFeature visualizerSupport "visualizer")
    (lib.withFeature visualizerSupport "fftw")
    (lib.enableFeature clockSupport "clock")
    (lib.withFeature taglibSupport "taglib")
    (lib.withFeatureAs true "boost" boost.dev)
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    boost
    libmpdclient
    ncurses
    readline
    libiconv
    icu
    curl
  ]
  ++ lib.optional visualizerSupport fftw
  ++ lib.optional taglibSupport taglib;

  preConfigure = ''
    autoreconf -fiv
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # std::result_of was removed in c++20 and unusable for clang16
    substituteInPlace ./configure \
      --replace-fail "std=c++20" "std=c++17"
  '';

  meta = {
    description = "Featureful ncurses based MPD client inspired by ncmpc";
    homepage = "https://rybczak.net/ncmpcpp/";
    changelog = "https://github.com/ncmpcpp/ncmpcpp/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      koral
      lovek323
    ];
    platforms = lib.platforms.all;
    mainProgram = "ncmpcpp";
  };
}
