{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  breeze-icons,
  karchive,
  kconfig,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  kitemmodels,
  khtml,
  kio,
  kparts,
  kpty,
  kservice,
  kwidgetsaddons,
  libarchive,
  libzip,
  # Archive tools
  p7zip,
  lrzip,
  unar,
  # Unfree tools
  unfreeEnableUnrar ? false,
  unrar,
}:

let
  extraTools = [
    p7zip
    lrzip
    unar
  ] ++ lib.optional unfreeEnableUnrar unrar;
in

mkDerivation {
  pname = "ark";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    libarchive
    libzip
  ] ++ extraTools;

  propagatedBuildInputs = [
    breeze-icons
    karchive
    kconfig
    kcrash
    kdbusaddons
    khtml
    ki18n
    kiconthemes
    kio
    kitemmodels
    kparts
    kpty
    kservice
    kwidgetsaddons
  ];

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath extraTools)
  ];

  meta = {
    homepage = "https://apps.kde.org/ark/";
    description = "Graphical file compression/decompression utility";
    mainProgram = "ark";
    license =
      with lib.licenses;
      [
        gpl2
        lgpl3
      ]
      ++ lib.optional unfreeEnableUnrar unfree;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
