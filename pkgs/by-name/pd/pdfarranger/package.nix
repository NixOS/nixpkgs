{
  fetchFromGitHub,
  lib,
  wrapGAppsHook3,
  python3Packages,
  gtk3,
  poppler_gi,
  libhandy,
}:

python3Packages.buildPythonApplication rec {
  pname = "pdfarranger";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdfarranger";
    repo = "pdfarranger";
    rev = "refs/tags/${version}";
    hash = "sha256-bHV6EluA7xp+HyejnSWJwfRBDcTuZq5Gzz0KWIs0qhA=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  build-system = with python3Packages; [ setuptools ];

  buildInputs = [
    gtk3
    poppler_gi
    libhandy
  ];

  dependencies = with python3Packages; [
    pygobject3
    pikepdf
    img2pdf
    setuptools
    python-dateutil
  ];

  # incompatible with wrapGAppsHook3
  strictDeps = false;
  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  doCheck = false; # no tests

  meta = {
    inherit (src.meta) homepage;
    description = "Merge or split pdf documents and rotate, crop and rearrange their pages using a graphical interface";
    mainProgram = "pdfarranger";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ symphorien ];
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/pdfarranger/pdfarranger/releases/tag/${version}";
  };
}
