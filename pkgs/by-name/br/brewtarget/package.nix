{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
  boost,
  pandoc,
  pkg-config,
  xercesc,
  xalanc,
  qt6Packages,
}:
let
  valijson = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v1.0.4";
    hash = "sha256-nIXcS8PMKoo8D616uUZ+GdIbkGb3VGSlCvg7QqZtz20=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "brewtarget";
  version = "4.0.17";

  src = fetchFromGitHub {
    owner = "Brewtarget";
    repo = "brewtarget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LN1pSzrxhcQ7/lS7PWSeSNEUhrPIVefQmjX+vQdaPCk=";
  };

  postPatch = ''
    # 3 sed statements from below derived from AUR
    # Disable boost-stacktrace_backtrace, requires an optional boost lib that's only built in Debianland
    sed -i "/boostModules += 'stacktrace_backtrace'/ {N;N;d}" meson.build
    # Make libbacktrace not required, we're not running the bt script
    sed -i "/compiler\.find_library('backtrace'/ {n;s/true/false/}" meson.build
    # Disable static linking
    sed -i 's/static : true/static : false/g' meson.build

    # Deal with submodules -- symlink valijson
    rm -r third-party/valijson && ln -sf ${valijson} third-party/valijson
  '';

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config
    qt6Packages.wrapQtAppsHook
    pandoc
  ];
  buildInputs = with qt6Packages; [
    boost
    qtbase
    qttools
    qtmultimedia
    qtsvg
    xercesc
    xalanc
  ];

  meta = with lib; {
    description = "Open source beer recipe creation tool";
    mainProgram = "brewtarget";
    homepage = "http://www.brewtarget.org/";
    license = licenses.gpl3;
    maintainers = [
      maintainers.avnik
      maintainers.mmahut
    ];
  };
})
