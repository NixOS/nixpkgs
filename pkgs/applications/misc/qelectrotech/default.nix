{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  qmake,
  qtbase,
  kcoreaddons,
  kwidgetsaddons,
  qtsvg,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "qelectrotech";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "qelectrotech";
    repo = "qelectrotech-source-mirror";
    tag = "0.9";
    hash = "sha256-tj8q+mRVtdeDXbpiv4retdbNiIfvAFlutXn7BmjqFYU=";
  };

  postPatch = ''
    substituteInPlace qelectrotech.pro \
      --replace-fail 'GIT_COMMIT_SHA="\\\"$(shell git -C \""$$_PRO_FILE_PWD_"\" rev-parse --verify HEAD)\\\""' \
                'GIT_COMMIT_SHA="\\\"${version}\\\""' \
      --replace-fail "COMPIL_PREFIX              = '/usr/local/'" \
                "COMPIL_PREFIX              = '$out/'" \
      --replace-fail "INSTALL_PREFIX             = '/usr/local/'" \
                "INSTALL_PREFIX             = '$out/'"
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    kcoreaddons
    kwidgetsaddons
    qtbase
    qtsvg
  ];

  qmakeFlags = [
    "INSTALLROOT=$(out)"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 qelectrotech $out/bin/qelectrotech

    install -Dm444 -t $out/share/applications misc/qelectrotech.desktop

    mkdir -p $out/share/qelectrotech
    cp -r elements $out/share/qelectrotech
    cp -r titleblocks $out/share/qelectrotech
    cp -r lang $out/share/qelectrotech
    cp -r examples $out/share/qelectrotech

    mkdir -p $out/share/icons/hicolor
    cp -r ico $out/share/icons/hicolor

    runHook postInstall
  '';

  meta = {
    description = "Free software to create electric diagrams";
    mainProgram = "qelectrotech";
    homepage = "https://qelectrotech.org/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ yvesf ];
    platforms = qtbase.meta.platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
