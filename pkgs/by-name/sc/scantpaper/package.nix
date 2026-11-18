{
  lib,
  python3,
  fetchFromGitHub,
  wrapGAppsHook4,

  # libs
  gobject-introspection,
  unpaper,
  djvulibre,
  libtiff,
  qpdf,
  imagemagick,
  jbig2enc,
  poppler-utils,
  ghostscript_headless,
  xdg-utils,

  # tests
  appstream,
  dejavu_fonts,
  writableTmpDirAsHomeHook,
  xvfb,
  imagemagickBig,
  tesseract,
}:

let
  runtimeExecDeps = [
    unpaper
    tesseract
    djvulibre
    libtiff
    qpdf
    ghostscript_headless
    imagemagick
    jbig2enc
    poppler-utils
    xdg-utils
  ];

in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "scantpaper";
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "carygravel";
    repo = "scantpaper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sn8VvMSMyWaEWhEHQrIUlW9BXGG9dnIKwgpsUkPd74s=";
  };

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postPatch = ''
    # `test_qbfox_fc_match_fallback` assumes `/usr/share/fonts/truetype/`
    # exists with a handful of fonts in it. This one font is enough to make
    # the test happy.
    substituteInPlace src/scantpaper/tests/test_conftest_helpers.py \
      --replace-fail "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf" "${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf"
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    img2pdf
    ocrmypdf
    pikepdf
    pillow
    pycairo
    pygobject3
    python-iso639
    sane
    tesserocr
    typing-extensions
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # In nixpkgs, we only want to test the functionality of a package,
    # not coverage, formatting, or type checking.
    "dev/tests/test_check_test_coverage.py"
  ];

  nativeCheckInputs =
    (with python3.pkgs; [
      polib
      pytestCheckHook
      pytest-cov-stub
      pytest-mock
      pytest-xvfb
      pytest-timeout
      tomli
    ])
    ++ [
      xvfb
      imagemagickBig # "big" version needed for text rendering in tests
      appstream # Provides `appstreamcli` used by `test_appstream_validate`.
    ]
    ++ runtimeExecDeps;

  preInstallCheck = ''
    # Some tests exercise gtk code that expects to find the relevant gsettings schemas.
    # This is a simplified version of what wrapGAppsHook4 does. There's no good way to compose
    # that with pytestCheckHook, though.
    export XDG_DATA_DIRS=$GSETTINGS_SCHEMAS_PATH:$XDG_DATA_DIRS
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath runtimeExecDeps)
  ];

  postInstall = ''
    install -Dm644 \
      src/scantpaper/icons/hicolor/scalable/apps/scantpaper.svg \
      $out/share/icons/hicolor/scalable/apps/scantpaper.svg

    install -Dm444 \
      org.scantpaper.desktop \
      $out/share/applications/org.scantpaper.desktop

    install -Dm644 org.scantpaper.desktop.metainfo.xml -t $out/share/metainfo
  '';

  meta = {
    changelog = "https://github.com/carygravel/scantpaper/blob/${finalAttrs.src.tag}/changelog.md";
    description = "GUI to produce PDFs or DjVus from scanned documents";
    homepage = "https://github.com/carygravel/scantpaper";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ euxane ];
    platforms = lib.platforms.linux;
    mainProgram = "scantpaper";
  };
})
