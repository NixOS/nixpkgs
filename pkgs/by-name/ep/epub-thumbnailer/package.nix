{ lib
, python3
, fetchFromGitHub
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication {
  pname = "epub-thumbnailer";
  version = "0-unstable-2024-03-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marianosimone";
    repo = "epub-thumbnailer";
    rev = "035c31e9269bcb30dcc20fed31b6dc54e9bfed63";
    hash = "sha256-G/CeYmr+wgJidbavfvIuCbRLJGQzoxAnpo3t4YFJq0c=";
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
