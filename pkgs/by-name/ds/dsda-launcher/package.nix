{ lib
, stdenv
, fetchFromGitHub
, qt6
}:
stdenv.mkDerivation rec {
  pname = "dsda-launcher";
  version = "1.3.1-hotfix";

  src = fetchFromGitHub {
    owner = "Pedro-Beirao";
    repo = "dsda-launcher";
    rev = "v${version}";
    hash = "sha256-V6VLUl148L47LjKnPe5MZCuhZSMtI0wd18i8b+7jCvk=";
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [ qt6.qtbase qt6.qtwayland ];

  buildPhase = ''
    runHook preBuild
    mkdir -p "./dsda-launcher/build"
    cd "./dsda-launcher/build"
    qmake6 ..
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./dsda-launcher $out/bin

    install -Dm444 ../icons/dsda-Launcher.desktop $out/share/applications/dsda-Launcher.desktop
    install -Dm444 ../icons/dsda-launcher.png $out/share/pixmaps/dsda-launcher.png
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Pedro-Beirao/dsda-launcher";
    description = "This is a launcher GUI for the dsda-doom source port";
    mainProgram = "dsda-launcher";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.Gliczy ];
  };
}
