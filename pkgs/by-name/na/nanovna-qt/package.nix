{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  fftw,
  eigen,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "nanovna-qt";
  # 20200507 dropped support for NanoVNA V2.2
  version = "20200403";

  src = fetchFromGitHub {
    owner = "nanovna-v2";
    repo = "NanoVNA-QT";
    rev = version;
    hash = "sha256-0nRpjLglCog9e4bSkaNSwjrwmLwut3Ykr3AaYZCaMEs=";
  };

  patches = [ ./fix-build.patch ];

  nativeBuildInputs = [
    autoreconfHook
    libtool
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    fftw
    eigen
    qt5.qtbase
    qt5.qtcharts
  ];

  autoreconfFlags = [ "--install" ];

  postBuild = ''
    pushd libxavna/xavna_mock_ui/
    qmake
    make
    popd
    pushd vna_qt/
    qmake
    make
    popd
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 vna_qt/vna_qt -t $out/bin/
    install -Dm555 libxavna/.libs/libxavna.so.0.0.0 -t $out/lib/
    ln -s libxavna.so.0.0.0 $out/lib/libxavna.so.0
    ln -s libxavna.so.0.0.0 $out/lib/libxavna.so
    install -Dm555 libxavna/xavna_mock_ui/libxavna_mock_ui.so.1.0.0 -t $out/lib/
    ln -s libxavna_mock_ui.so.1.0.0 $out/lib/libxavna_mock_ui.so.1.0
    ln -s libxavna_mock_ui.so.1.0.0 $out/lib/libxavna_mock_ui.so.1
    ln -s libxavna_mock_ui.so.1.0.0 $out/lib/libxavna_mock_ui.so
    runHook postInstall
  '';

  preFixup = ''
    qtWrapperArgs+=(--prefix LD_LIBRARY_PATH : "$out/lib")
  '';

  meta = {
    description = "PC GUI software for NanoVNA V2 series";
    homepage = "https://nanorfe.com/nanovna-v2.html";
    mainProgram = "vna_qt";
    license = lib.licenses.gpl2Only;
    changelog = "https://github.com/nanovna-v2/NanoVNA-QT/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.linux;
  };
}
