{
  lib,
  python3,
  fetchFromGitHub,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication {
  pname = "epub-thumbnailer";
  version = "0.0.1-unstable-2026-11-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marianosimone";
    repo = "epub-thumbnailer";
    rev = "cae24eac78efa9d6777a775701a1e789898901c0";
    hash = "sha256-n4iKJcuu02FxGw+3DEl4MWIz7RsXYibBV3JH+/T9O60=";
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

  meta = {
    description = "Script to extract the cover of an epub book and create a thumbnail for it";
    homepage = "https://github.com/marianosimone/epub-thumbnailer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "epub-thumbnailer";
  };
}
