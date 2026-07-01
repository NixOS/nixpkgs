{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  cmake,
  libsForQt5,
  pugixml,
}:
let
  singleApplication = fetchFromGitHub {
    owner = "itay-grudev";
    repo = "SingleApplication";
    tag = "v3.2.0";
    hash = "sha256-qjpPYPe1Oism6TetD/dMvTo1qyZKOsOPW+MzzNpJf3A=";
  };
in
stdenv.mkDerivation rec {
  pname = "qelectrotech";
  version = "0.100";

  src = fetchFromGitHub {
    owner = "qelectrotech";
    repo = "qelectrotech-source-mirror";
    tag = version;
    hash = "sha256-ElkqRiIHSXavXEw1ioFKL1cGnaBb2GXZuxgl98O4WuI=";
  };

  patches = [
    # stripped down version of https://codeberg.org/gentoo/gentoo/src/branch/master/sci-electronics/qelectrotech/files/qelectrotech-0.90_pre20250820-cmake.patch
    ./system-pugixml.patch
    # Qt-only replacements for upstream's KF5 color widgets.
    ./qt-color-widgets.patch
  ];

  # fix wrong cmake conditional
  postPatch = ''
    substituteInPlace cmake/fetch_kdeaddons.cmake \
      --replace-fail "DEFINED BUILD_WITH_KF5" "BUILD_WITH_KF5"
  '';

  cmakeFlags = [
    "-DBUILD_WITH_KF5=OFF"
    # relies on vendored catch2
    "-DPACKAGE_TESTS=OFF"
    "-DFETCHCONTENT_SOURCE_DIR_SINGLEAPPLICATION=${singleApplication}"
    "-DBUILD_PUGIXML=OFF"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    cmake
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
    pugixml
  ];

  qtWrapperArgs = [
    "--add-flags"
    "--common-elements-dir=${placeholder "out"}/share/qelectrotech/elements"
    "--add-flags"
    "--common-tbt-dir=${placeholder "out"}/share/qelectrotech/titleblocks"
    "--add-flags"
    "--lang-dir=${placeholder "out"}/share/qelectrotech/lang"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 qelectrotech $out/bin/qelectrotech

    install -Dm444 -t $out/share/applications ../misc/org.qelectrotech.qelectrotech.desktop

    mkdir -p $out/share/qelectrotech
    cp -r ../elements $out/share/qelectrotech
    cp -r ../titleblocks $out/share/qelectrotech
    cp -r ../lang $out/share/qelectrotech
    cp -r ../examples $out/share/qelectrotech

    mkdir -p $out/share/icons/hicolor
    cp -r ../ico $out/share/icons/hicolor

    runHook postInstall
  '';

  meta = {
    description = "Free software to create electric diagrams";
    mainProgram = "qelectrotech";
    homepage = "https://qelectrotech.org/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ yvesf ];
    platforms = libsForQt5.qtbase.meta.platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
