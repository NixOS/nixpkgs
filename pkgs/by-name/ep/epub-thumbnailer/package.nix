{ lib
, python3
, fetchFromGitHub
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication {
  pname = "epub-thumbnailer";
  version = "0-unstable-2024-03-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marianosimone";
    repo = "epub-thumbnailer";
    rev = "de4b5bf0fcd1817d560f180231f7bd22d330f1be";
    hash = "sha256-r0t2enybUEminXOHjx6uH6LvQtmzTRPZm/gY3Vi2c64=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pillow
  ];

  postInstall = ''
    mv $out/bin/epub-thumbnailer.py $out/bin/epub-thumbnailer
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Script to extract the cover of an epub book and create a thumbnail for it";
    homepage = "https://github.com/marianosimone/epub-thumbnailer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "epub-thumbnailer";
  };
}
