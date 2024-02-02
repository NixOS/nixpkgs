{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, itk
, cmake
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "aliza";
  version = "1.9.7";

  src = fetchFromGitHub {
    owner = "AlizaMedicalImaging";
    repo = "AlizaMS";
    rev = "v${version}";
    hash = "sha256-bambl3NP42KEwh6NPb8jhQlGqaUCSt6QuzUmmBnEAQw=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  buildInputs = [
    itk
    cmake
    qtbase
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE:STRING=Release"
    "-DALIZA_QT_VERSION:STRING=5"
    "-DITK_DIR:STRING=${itk}"
    "-DMDCM_USE_SYSTEM_ZLIB:BOOL=ON"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 ./bin/* -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Aliza MS DICOM Viewer";
    homepage = "https://www.aliza-dicom-viewer.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lux ];
    platforms = platforms.linux;
    mainProgram = "alizams";
  };
}
