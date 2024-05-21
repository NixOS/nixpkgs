{ fetchFromGitHub
, lib
, wrapGAppsHook3
, python3Packages
, gtk3
, poppler_gi
, libhandy
}:

python3Packages.buildPythonApplication rec {
  pname = "pdfarranger";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdfarranger";
    repo = "pdfarranger";
    rev = "refs/tags/${version}";
    hash = "sha256-l//DeaIqUl6FdGFxM8yTKcTjVNvYMllorcoXoK33Iy4=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
  ] ++ (with python3Packages; [
    setuptools
  ]);

  buildInputs = [
    gtk3
    poppler_gi
    libhandy
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pikepdf
    img2pdf
    setuptools
    python-dateutil
  ];

  # incompatible with wrapGAppsHook3
  strictDeps = false;
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = false; # no tests

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Merge or split pdf documents and rotate, crop and rearrange their pages using an interactive and intuitive graphical interface";
    mainProgram = "pdfarranger";
    platforms = platforms.linux;
    maintainers = with maintainers; [ symphorien ];
    license = licenses.gpl3Plus;
    changelog = "https://github.com/pdfarranger/pdfarranger/releases/tag/${version}";
  };
}
