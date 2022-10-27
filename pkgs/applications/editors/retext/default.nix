{ lib
, python3
, fetchFromGitHub
, wrapQtAppsHook
, buildEnv
, aspellDicts
  # Use `lib.collect lib.isDerivation aspellDicts;` to make all dictionaries
  # available.
, enchantAspellDicts ? with aspellDicts; [ en en-computers en-science ]
}:

python3.pkgs.buildPythonApplication rec {
  pname = "retext";
  version = "7.2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "retext-project";
    repo = "retext";
    rev = version;
    hash = "sha256-EwaJFODnkZGbqVw1oQrTrx2ME4vRttVW4CMPkWvMtHA=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    docutils
    markdown
    markups
    pyenchant
    pygments
    pyqt5
  ];

  postPatch = ''
    # Remove wheel check
    sed -i -e '31,36d' setup.py
  '';

  postInstall = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(
      "--set" "ASPELL_CONF" "dict-dir ${buildEnv {
        name = "aspell-all-dicts";
        paths = map (path: "${path}/lib/aspell") enchantAspellDicts;
      }}"
    )

    substituteInPlace $out/share/applications/me.mitya57.ReText.desktop \
      --replace "Exec=ReText-${version}.data/scripts/retext %F" "Exec=$out/bin/retext %F" \
      --replace "Icon=ReText-${version}.data/data/share/retext/icons/retext.svg" "Icon=$out/share/retext/icons/retext.svg"
  '';

  doCheck = false;

  pythonImportsCheck = [
    "ReText"
  ];

  meta = with lib; {
    description = "Editor for Markdown and reStructuredText";
    homepage = "https://github.com/retext-project/retext/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.unix;
  };
}
