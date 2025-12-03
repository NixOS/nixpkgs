{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchurl,
  makeDesktopItem,
  cmake,
  boost,
  bzip2,
  ffmpeg,
  fftwSinglePrec,
  hdf5,
  muparser,
  netcdf,
  openssl,
  python3,
  qt6Packages,
  copyDesktopItems,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ovito";
  version = "3.14.1";

  src = fetchFromGitLab {
    owner = "stuko";
    repo = "ovito";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SKE07bk/8cZ2etQtLrGZyp2DrNiyVk6mrgxlvJmG+Xk=";
    fetchSubmodules = true;
  };
  patches = [ ./zstd.patch ];

  nativeBuildInputs = [
    cmake
    qt6Packages.wrapQtAppsHook
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
    qt6Packages.qscintilla
    qt6Packages.qtbase
    qt6Packages.qtsvg
    qt6Packages.qttools
    # needed to run natively on wayland
    qt6Packages.qtwayland
  ];

  # manually create a desktop file
  desktopItems = [
    (makeDesktopItem {
      name = "ovito";
      comment = "Open Visualization Tool";
      exec = "ovito";
      icon = "ovito";
      terminal = false;
      startupNotify = false;
      desktopName = "ovito";
      startupWMClass = "Ovito";
      categories = [ "Science" ];
    })
  ];

  postInstall =
    let
      icon = fetchurl {
        url = "https://www.ovito.org/wp-content/uploads/logo_rgb-768x737.png";
        hash = "sha256-FOmIUeXem+4MjavQNag0UIlcR2wa2emJjivwxoJh6fI=";
      };
    in
    ''
      install -Dm644 ${icon} $out/share/pixmaps/ovito.png
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scientific visualization and analysis software for atomistic and particle simulation data";
    mainProgram = "ovito";
    homepage = "https://ovito.org";
    changelog = "https://docs.ovito.org/new_features.html";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [
      twhitehead
      chn
      chillcicada
    ];
    broken = stdenv.hostPlatform.isDarwin; # clang-11: error: no such file or directory: '$-DOVITO_COPYRIGHT_NOTICE=...
  };
})
