{ lib
, python3
, fetchzip
, fetchFromGitHub
, wrapQtAppsHook
, qtbase
, qttools
, qtsvg
, buildEnv
, aspellDicts
  # Use `lib.collect lib.isDerivation aspellDicts;` to make all dictionaries
  # available.
, enchantAspellDicts ? with aspellDicts; [ en en-computers en-science ]
}:

python3.pkgs.buildPythonApplication rec {
  pname = "retext";
  version = "8.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "retext-project";
    repo = pname;
    rev = version;
    hash = "sha256-22yqNwIehgTfeElqhN5Jzye7LbcAiseTeoMgenpmsL0=";
  };

  toolbarIcons = fetchzip {
    url = "https://github.com/retext-project/retext/archive/icons.zip";
    hash = "sha256-LQtSFCGWcKvXis9pFDmPqAMd1m6QieHQiz2yykeTdnI=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    qttools.dev
  ];

  buildInputs = [
    qtbase
    qtsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    docutils
    markdown
    markups
    pyenchant
    pygments
    pyqt6
    pyqt6-webengine
  ];

  patches = [ ./remove-wheel-check.patch ];

  preConfigure = ''
    lrelease ReText/locale/*.ts
  '';

  # prevent double wrapping
  dontWrapQtApps = true;

  postInstall = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(
      "--set" "ASPELL_CONF" "dict-dir ${buildEnv {
        name = "aspell-all-dicts";
        paths = map (path: "${path}/lib/aspell") enchantAspellDicts;
      }}"
    )

    cp ${toolbarIcons}/* $out/${python3.pkgs.python.sitePackages}/ReText/icons

    substituteInPlace $out/share/applications/me.mitya57.ReText.desktop \
      --replace "Exec=ReText-${version}.data/scripts/retext %F" "Exec=$out/bin/retext %F" \
      --replace "Icon=ReText/icons/retext.svg" "Icon=retext"
  '';

  doCheck = false;

  pythonImportsCheck = [
    "ReText"
  ];

  meta = with lib; {
    description = "Editor for Markdown and reStructuredText";
    homepage = "https://github.com/retext-project/retext/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.unix;
  };
}
