{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  makeDesktopItem,
  copyDesktopItems,
  cmake,
  boost,
  cups,
  fmt,
  libvorbis,
  libsndfile,
  minizip,
  gtest,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsd2dsl";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "nongeneric";
    repo = "lsd2dsl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0UsxDNpuWpBrfjh4q3JhZnOyXhHatSa3t/cApiG2JzM=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/nongeneric/lsd2dsl/commit/bbda5be1b76a4a44804483d00c07d79783eceb6b.patch";
      hash = "sha256-7is83D1cMBArXVLe5TP7D7lUcwnTMeXjkJ+cbaH5JQk=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "-Werror" ""
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux copyDesktopItems;

  buildInputs = [
    boost
    cups
    fmt
    libvorbis
    libsndfile
    minizip
    gtest
    qt6.qt5compat
    qt6.qtwebengine
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-int-conversion";

  desktopItems = lib.singleton (makeDesktopItem {
    name = "lsd2dsl";
    exec = "lsd2dsl-qtgui";
    desktopName = "lsd2dsl";
    genericName = "lsd2dsl";
    comment = finalAttrs.meta.description;
    categories = [
      "Dictionary"
      "FileTools"
      "Qt"
    ];
  });

  installPhase = ''
    install -Dm755 console/lsd2dsl gui/lsd2dsl-qtgui -t $out/bin
  '';

  meta = {
    homepage = "https://rcebits.com/lsd2dsl/";
    description = "Lingvo dictionaries decompiler";
    longDescription = ''
      A decompiler for ABBYY Lingvo’s proprietary dictionaries.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
})
