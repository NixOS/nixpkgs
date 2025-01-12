{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "dracula-theme";
  version = "unstable-2022-05-21";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "qt5";
    rev = "7b25ee305365f6e62efb2c7aca3b4635622b778c";
    hash = "sha256-tfUjAb+edbJ+5qar4IxWr4h3Si6MIwnbCrwI2ZdUFAM=";
  };

  installPhase = ''
    runHook preInstall

    install -D Dracula.conf $out/share/qt5ct/colors/Dracula.conf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dark theme for qt5";
    homepage = "https://github.com/dracula/qt5";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vonfry ];
  };
}
