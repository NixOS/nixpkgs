{ stdenv, lib, fetchFromGitHub, qmake, qtbase, wrapQtAppsHook }:

stdenv.mkDerivation {
  pname = "selectdefaultapplication";
  version = "unstable-2021-08-12";

  src = fetchFromGitHub {
    owner = "sandsmark";
    repo = "selectdefaultapplication";
    rev = "c752df6ba8caceeef54bcf6527f1bccc2ca8202a";
    sha256 = "C/70xpt6RoQNIlAjSJhOCyheolK4Xp6RiSZmeqMP4fw=";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];
  buildInputs = [ qtbase ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp selectdefaultapplication $out/bin

    install -Dm644 -t "$out/share/applications" selectdefaultapplication.desktop
    install -Dm644 -t "$out/share/icons/hicolor/48x48/apps" selectdefaultapplication.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "Very simple application that lets you define default applications on Linux in a sane way";
    mainProgram = "selectdefaultapplication";
    homepage = "https://github.com/sandsmark/selectdefaultapplication";
    maintainers = with maintainers; [ nsnelson ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
