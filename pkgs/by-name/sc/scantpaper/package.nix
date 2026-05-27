{
  lib,
  python3,
  fetchFromGitHub,
  wrapGAppsHook3,

  # libs
  gobject-introspection,
  goocanvas_2,
  unpaper,
  djvulibre,
  libtiff,
  qpdf,

  # tests
  writableTmpDirAsHomeHook,
  xvfb,
  imagemagickBig,
  poppler-utils,
  ghostscript,
  tesseract,
}:

let
  runtimeExecDeps = [
    unpaper
    tesseract
    djvulibre
    libtiff
    qpdf
  ];

in
python3.pkgs.buildPythonApplication rec {
  pname = "scantpaper";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "carygravel";
    repo = "scantpaper";
    rev = "v${version}";
    hash = "sha256-CKD6hggVIHNPAft+DAsF4S+uZo+u/gbUStz9VaZtDBM=";
  };

  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postPatch = ''
    # disable formatting check, which breaks on Black version change
    substituteInPlace pyproject.toml \
      --replace "--black" ""
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies =
    (with python3.pkgs; [
      img2pdf
      ocrmypdf
      pycairo
      pygobject3
      sane
      tesserocr
      python-iso639
    ])
    ++ [
      goocanvas_2
    ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    writableTmpDirAsHomeHook
  ];

  nativeCheckInputs =
    (with python3.pkgs; [
      pytestCheckHook
      pytest-cov # segfault with pytest-cov-stub
      pytest-mock
      pytest-xvfb
      pytest-timeout
    ])
    ++ [
      xvfb
      imagemagickBig # "big" version needed for text rendering in tests
      poppler-utils
      ghostscript
    ]
    ++ runtimeExecDeps;

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath runtimeExecDeps)
  ];

  meta = with lib; {
    description = "GUI to produce PDFs or DjVus from scanned documents";
    homepage = "https://github.com/carygravel/scantpaper";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ euxane ];
    platforms = platforms.linux;
    mainProgram = "scantpaper";
  };
}
