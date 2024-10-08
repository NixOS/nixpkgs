{ lib
, stdenv
, mkDerivation
, fetchzip
, installShellFiles
, pkg-config
, qmake
, qtbase
, kcoreaddons
, kwidgetsaddons
}:

mkDerivation rec {
  pname = "qelectrotech";
  version = "0.8.0";

  src = fetchzip {
    url = "https://git.tuxfamily.org/qet/qet.git/snapshot/qet-${version}.tar.gz";
    sha256 = "sha256-op2vnMPF9bNnHGphWFB/HEeoThE6tX+9UvX8LWVwkzI=";
  };

  postPatch = ''
    substituteInPlace qelectrotech.pro \
      --replace 'GIT_COMMIT_SHA="\\\"$(shell git -C \""$$_PRO_FILE_PWD_"\" rev-parse --verify HEAD)\\\""' \
                'GIT_COMMIT_SHA="\\\"${version}\\\""' \
      --replace "COMPIL_PREFIX              = '/usr/local/'" \
                "COMPIL_PREFIX              = '$out/'" \
      --replace "INSTALL_PREFIX             = '/usr/local/'" \
                "INSTALL_PREFIX             = '$out/'"
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    qmake
  ];

  buildInputs = [
    kcoreaddons
    kwidgetsaddons
    qtbase
  ];

  qmakeFlags = [
    "INSTALLROOT=$(out)"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 qelectrotech $out/bin/qelectrotech

    install -Dm444 -t $out/share/applications misc/qelectrotech.desktop
    install -Dm444 -t $out/share/applications misc/x-qet-titleblock.desktop
    install -Dm444 -t $out/share/applications misc/x-qet-element.desktop
    install -Dm444 -t $out/share/applications misc/x-qet-project.desktop

    mkdir -p $out/share/qelectrotech
    cp -r elements $out/share/qelectrotech
    cp -r titleblocks $out/share/qelectrotech
    cp -r lang $out/share/qelectrotech
    cp -r examples $out/share/qelectrotech

    mkdir -p $out/share/icons/hicolor
    cp -r ico $out/share/icons/hicolor

    runHook postInstall
  '';

  meta = with lib; {
    description = "Free software to create electric diagrams";
    mainProgram = "qelectrotech";
    homepage = "https://qelectrotech.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ yvesf ];
    platforms = qtbase.meta.platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
