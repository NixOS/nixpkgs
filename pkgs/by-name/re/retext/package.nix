{
  lib,
  python3Packages,
  fetchzip,
  fetchFromGitHub,
  qt6,
  buildEnv,
  aspellDicts,
  # Use `lib.collect lib.isDerivation aspellDicts;` to make all dictionaries
  # available.
  enchantAspellDicts ? with aspellDicts; [
    en
    en-computers
  ],
}:

python3Packages.buildPythonApplication rec {
  pname = "retext";
  version = "8.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "retext-project";
    repo = "retext";
    tag = version;
    hash = "sha256-npQ1eVb2iyswbqxi262shC9u/g9oE0ofkLbisFgqQM4=";
  };

  toolbarIcons = fetchzip {
    url = "https://github.com/retext-project/retext/archive/icons.zip";
    hash = "sha256-nqKAUg9nTzGPPxr80KTn6JX9JgCUJwpcwp8aOIlcxPY=";
  };

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qttools.dev
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  dependencies = with python3Packages; [
    chardet
    docutils
    markdown
    markups
    pyenchant
    pygments
    pyqt6
    pyqt6-webengine
  ];

  # disable wheel check
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "self.root and self.root.endswith('/wheel')" "False"
  '';

  preConfigure = ''
    lrelease ReText/locale/*.ts
  '';

  # prevent double wrapping
  dontWrapQtApps = true;

  postInstall = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(
      "--set" "ASPELL_CONF" "dict-dir ${
        buildEnv {
          name = "aspell-all-dicts";
          paths = map (path: "${path}/lib/aspell") enchantAspellDicts;
        }
      }"
    )

    cp ${toolbarIcons}/* $out/${python3Packages.python.sitePackages}/ReText/icons

    substituteInPlace $out/share/applications/me.mitya57.ReText.desktop \
      --replace-fail "Exec=retext-${version}.data/scripts/retext %F" "Exec=retext %F" \
      --replace-fail "Icon=./ReText/icons/retext.svg" "Icon=retext"
  '';

  doCheck = false;

  pythonImportsCheck = [
    "ReText"
  ];

  meta = {
    description = "Editor for Markdown and reStructuredText";
    homepage = "https://github.com/retext-project/retext/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ klntsky ];
    platforms = lib.platforms.unix;
    mainProgram = "retext";
  };
}
