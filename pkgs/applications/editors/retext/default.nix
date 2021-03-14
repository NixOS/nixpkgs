{ lib, python3, fetchFromGitHub, wrapQtAppsHook, buildEnv, aspellDicts
# Use `lib.collect lib.isDerivation aspellDicts;` to make all dictionaries
# available.
, enchantAspellDicts ? with aspellDicts; [ en en-computers en-science ]
}:

let
  version = "7.0.4";
  pythonEnv = python3.withPackages (ps: with ps; [
    pyqt5 docutils pyenchant Markups markdown pygments chardet
  ]);
in python3.pkgs.buildPythonApplication {
  inherit version;
  pname = "retext";

  src = fetchFromGitHub {
    owner = "retext-project";
    repo = "retext";
    rev = version;
    sha256 = "1zcapywspc9v5zf5cxqkcy019np9n41gmryqixj66zsvd544c6si";
  };

  doCheck = false;

  nativeBuildInputs = [ wrapQtAppsHook ];
  propagatedBuildInputs = [ pythonEnv ];

  postInstall = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(
      "--set" "ASPELL_CONF" "dict-dir ${buildEnv {
        name = "aspell-all-dicts";
        paths = map (path: "${path}/lib/aspell") enchantAspellDicts;
      }}"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/retext-project/retext/";
    description = "Simple but powerful editor for Markdown and reStructuredText";
    license = licenses.gpl3;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.unix;
  };
}
