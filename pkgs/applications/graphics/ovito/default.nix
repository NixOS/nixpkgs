{ lib
, stdenv
, fetchFromGitLab
, fetchurl
, makeDesktopItem
, cmake
, boost
, bzip2
, ffmpeg
, fftwSinglePrec
, hdf5
, muparser
, netcdf
, openssl
, python3
, qscintilla
, qtbase
, qtsvg
, qttools
, VideoDecodeAcceleration
, wrapQtAppsHook
, copyDesktopItems
# needed to run natively on wayland
, qtwayland
}:

stdenv.mkDerivation rec {
  pname = "ovito";
  version = "3.11.1";

  src = fetchFromGitLab {
    owner = "stuko";
    repo = "ovito";
    rev = "v${version}";
    hash = "sha256-ulzcsFAiZDg8nABQXNB2/MS7lZdK3czGHLKgKDWS15E=";
    fetchSubmodules = true;
  };
  patches = [ ./zstd.patch ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    boost
    bzip2
    ffmpeg
    fftwSinglePrec
    hdf5
    muparser
    netcdf
    openssl
    python3
    qscintilla
    qtbase
    qtsvg
    qttools
    qtwayland
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    VideoDecodeAcceleration
  ];

  # manually create a desktop file
  desktopItems = [ (makeDesktopItem {
    name = "ovito";
    comment= "Open Visualization Tool";
    exec = "ovito";
    icon = "ovito";
    terminal = false;
    startupNotify = false;
    desktopName = "ovito";
    startupWMClass = "Ovito";
    categories = [ "Science" ];
  })];

  postInstall = let
    icon = fetchurl {
      url = "https://www.ovito.org/wp-content/uploads/logo_rgb-768x737.png";
      hash = "sha256-FOmIUeXem+4MjavQNag0UIlcR2wa2emJjivwxoJh6fI=";
    };
  in ''
    install -Dm644 ${icon} $out/share/pixmaps/ovito.png
  '';

  meta = with lib; {
    description = "Scientific visualization and analysis software for atomistic and particle simulation data";
    mainProgram = "ovito";
    homepage = "https://ovito.org";
    license = with licenses;  [ gpl3Only mit ];
    maintainers = with maintainers; [
      twhitehead
      chn
    ];
    broken = stdenv.hostPlatform.isDarwin; # clang-11: error: no such file or directory: '$-DOVITO_COPYRIGHT_NOTICE=...
  };
}
