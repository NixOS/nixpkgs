{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  qt6,
  libusb-compat-0_1,
  gsl,
  blas,
  bison,
  flex,
  zlib,
  makeDesktopItem,
}:

let
  desktopItem = makeDesktopItem {
    name = "goldencheetah";
    exec = "GoldenCheetah";
    icon = "goldencheetah";
    desktopName = "GoldenCheetah";
    genericName = "GoldenCheetah";
    comment = "Performance software for cyclists, runners and triathletes";
    categories = [ "Utility" ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "golden-cheetah";
  version = "3.7";

  src = fetchFromGitHub {
    owner = "GoldenCheetah";
    repo = "GoldenCheetah";
    tag = "v${finalAttrs.version}";
    hash = "sha256-INlkFWugIoln7wrmgLZUC/Ye8eV+mlT6BZ0ZdP7CiqE=";
  };

  buildInputs =
    with qt6;
    [
      qt5compat
      qtbase
      qtcharts
      qtconnectivity
      qtmultimedia
      qtserialport
      qtsvg
      qttools
      qtwebengine
    ]
    ++ [
      blas
      gsl
      libusb-compat-0_1
      zlib
    ];
  nativeBuildInputs = [
    bison
    flex
  ]
  ++ (with qt6; [
    qmake
    wrapQtAppsHook
  ]);

  patches = [
    # allow building with bison 3.7
    # Included in https://github.com/GoldenCheetah/GoldenCheetah/pull/3590,
    # which is periodically rebased but pre 3.6 release, as it'll break other CI systems
    ./0001-Fix-building-with-bison-3.7.patch
  ];

  NIX_LDFLAGS = "-lz -lgsl -lblas";

  qtWrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "${zlib.out}/lib"
  ];

  preConfigure = ''
    cp src/gcconfig.pri.in src/gcconfig.pri
    cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri
    sed -i 's,^#QMAKE_LRELEASE.*,QMAKE_LRELEASE = ${qt6.qttools.dev}/bin/lrelease,' src/gcconfig.pri
    sed -i 's,^#LIBUSB_INSTALL.*,LIBUSB_INSTALL = ${libusb-compat-0_1},' src/gcconfig.pri
    sed -i 's,^#LIBUSB_INCLUDE.*,LIBUSB_INCLUDE = ${libusb-compat-0_1.dev}/include,' src/gcconfig.pri
    sed -i 's,^#LIBUSB_LIBS.*,LIBUSB_LIBS = -L${libusb-compat-0_1}/lib -lusb,' src/gcconfig.pri
  '';

  installPhase =
    if stdenv.hostPlatform.isLinux then
      ''
        runHook preInstall

        mkdir -p $out/bin
        cp src/GoldenCheetah $out/bin
        install -Dm644 "${desktopItem}/share/applications/"* -t $out/share/applications/
        install -Dm644 src/Resources/images/gc.png $out/share/pixmaps/goldencheetah.png

        runHook postInstall
      ''
    else if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -r src/GoldenCheetah.app $out/Applications
        runHook postInstall
      ''
    else
      abort "unsupported platform";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Performance software for cyclists, runners and triathletes. Built from source and without API tokens";
    mainProgram = "GoldenCheetah";
    platforms = with lib.platforms; darwin ++ linux;
    maintainers = with lib.maintainers; [ adamcstephens ];
    license = lib.licenses.gpl2Plus;
  };
})
