{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  cmake,

  curl,
  ffmpeg,
  libmediainfo,
  libzen,
  libsForQt5,
  qt6Packages,

  qtVersion ? 6,
}:

let
  qt' = if qtVersion == 5 then libsForQt5 else qt6Packages;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "mediaelch";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m2d4lnyD8HhhqovMdeG36dMK+4kJA7rlPHE2tlhfevo=";
    fetchSubmodules = true;
  };

  patches = [
    # fix from: https://github.com/Komet/MediaElch/pull/1878
    (fetchpatch {
      url = "https://github.com/Komet/MediaElch/commit/dbea12fbf2c1fe603819392aa2a181cffa168548.patch";
      hash = "sha256-Lv6rvjKbRNr5XrdZhPyw4S4RRCOnfAGhWgcSLo0gqS8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    qt'.qttools
    qt'.wrapQtAppsHook
  ];

  buildInputs =
    [
      curl
      ffmpeg
      libmediainfo
      libzen
      qt'.qtbase
      qt'.qtdeclarative
      qt'.qtmultimedia
      qt'.qtsvg
      qt'.qtwayland
      qt'.quazip
    ]
    ++ lib.optionals (qtVersion == 6) [
      qt'.qt5compat
    ];

  cmakeFlags = [
    (lib.cmakeBool "DISABLE_UPDATER" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.doCheck or false)
    (lib.cmakeBool "MEDIAELCH_FORCE_QT${toString qtVersion}" true)
    (lib.cmakeBool "USE_EXTERN_QUAZIP" true)
  ];

  # libmediainfo.so.0 is loaded dynamically
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${libmediainfo}/lib"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://mediaelch.de/mediaelch/";
    description = "Media Manager for Kodi";
    mainProgram = "MediaElch";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.linux;
  };
})
