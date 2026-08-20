{
  lib,
  stdenv,
  fetchgit,
  callPackage,

  wafHook,
  wrapGAppsHook3,
  python3,
  gitMinimal,
  pkg-config,
  boost,
  curl,
  icu,
  libsamplerate,
  glib,
  libzip,
  bzip2,
  fontconfig,
  pangomm,
  libxmlxx,
  libssh,
  xmlsec,
  xercesc,
  ffmpeg-headless,
  fmt,
  nettle,
  libjpeg,
  sqlite,
  wxwidgets_3_2,
  rtaudio,
  libGL,
  libGLU,
  libsndfile,
  libtool,
  libharu,
  openssl,
  nlohmann_json,
}:
let
  libcxml = callPackage ./libcxml.nix { };
  leqm-nrt = callPackage ./leqm-nrt.nix { };
  asdcplib = callPackage ./asdcplib.nix { };
  libttf = callPackage ./libttf.nix { };
  libsub = callPackage ./libsub.nix { };
  libdcp = callPackage ./libdcp.nix { inherit libcxml asdcplib; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dcpomatic";
  version = "2.19.1";

  src = fetchgit {
    url = "https://git.carlh.net/git/dcpomatic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c+An8V/A7Vk0ChGQULk9uj0zN5slLb8wSKlWl+3uL1Y=";
  };

  nativeBuildInputs = [
    wafHook
    python3
    gitMinimal
    pkg-config
    fontconfig
    wrapGAppsHook3
    wxwidgets_3_2
  ];

  buildInputs = [
    boost
    curl
    icu
    libsamplerate
    glib
    libzip
    bzip2
    pangomm
    leqm-nrt
    libttf
    libcxml
    libxmlxx
    libssh
    libdcp
    xmlsec
    xercesc
    ffmpeg-headless
    fmt
    libsub
    nettle
    libjpeg
    sqlite
    wxwidgets_3_2
    rtaudio
    libGL
    libGLU
    libsndfile
    libtool
    libharu
    openssl
    nlohmann_json
  ];

  postInstall = ''
    ln -s ${openssl}/bin/openssl $out/bin/dcpomatic2_openssl
    ln -s ${libdcp}/share/libdcp $out/share/libdcp
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Convert video, audio and subtitles into DCP";
    homepage = "https://dcpomatic.com/";
    downloadPage = "https://git.carlh.net/cgit/dcpomatic";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ logn ];
  };
})
