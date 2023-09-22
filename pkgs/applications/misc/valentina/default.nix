{ lib, stdenv, fetchFromGitLab, installShellFiles
, qmake, qttools
, qtsvg, qtxmlpatterns
, wrapQtAppsHook
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "valentina";
  version = "0.7.52";

  src = fetchFromGitLab {
    owner = "smart-pattern";
    repo = "valentina";
    rev = "v${version}";
    hash = "sha256-DmNRBxqyBvDTdA7Sz9X04Dhejtxx7tOVpST+SkUNguM=";
  };

  postPatch = ''
    substituteInPlace src/app/translations.pri \
      --replace '$$[QT_INSTALL_BINS]/$$LRELEASE' '${lib.getDev qttools}/bin/lrelease'
  '';

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook installShellFiles autoPatchelfHook ];

  buildInputs = [ qtsvg qtxmlpatterns ];

  qmakeFlags = [
    "-r"
    "PREFIX=${placeholder "out"}"
    "CONFIG+=noTests"
    "CONFIG+=noRunPath"
    "CONFIG+=no_ccache"
    "CONFIG+=noDebugSymbols"
  ];

  postInstall = ''
    installManPage dist/debian/*.1
    install -Dm644 dist/debian/valentina.sharedmimeinfo $out/share/mime/packages/valentina.xml
  '';

  meta = with lib; {
    description = "An open source sewing pattern drafting software";
    homepage = "https://smart-pattern.com.ua/";
    changelog = "https://gitlab.com/smart-pattern/valentina/-/blob/v${version}/ChangeLog.txt";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
