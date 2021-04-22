{ lib
, buildPythonApplication
, fetchFromGitHub
, wrapQtAppsHook
, pytestCheckHook
, gettext
, hsaudiotag3k
, polib
, pyqt5
, send2trash
, sip
, sphinx
, distro
, pytest
}:

buildPythonApplication rec {
  pname = "dupeguru";
  version = "4.1.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "arsenetar";
    repo = "dupeguru";
    rev = version;
    sha256 = "1a34kkw2xyfdirv0nw5w6v7s2db4cfn17ksnnblkl7ahndr6hlnj";
  };

  nativeBuildInputs = [
    gettext
    pyqt5
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    hsaudiotag3k
    polib
    pyqt5
    send2trash
    sip
    sphinx
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "NO_VENV=1"
  ];

  # Needed otherwise we get segfault:
  # Cannot mix incompatible Qt library (5.15.2) with this library (5.15.3),
  # help needed to check what's causing this
  # cf https://github.com/NixOS/nixpkgs/pull/120322#issuecomment-1002330733
  preFixup = ''
    makeWrapperArgs="''${qtWrapperArgs[@]}"
  '';

  # Executable in $out/bin is a symlink to $out/share/dupeguru/run.py
  # so wrapPythonPrograms hook does not handle it automatically.
  postFixup = ''
    wrapPythonProgramsIn "$out/share/dupeguru" "$out $propagatedBuildInputs"
  '';

  doCheck = true;

  checkInputs = [
    pytestCheckHook
    distro
    send2trash
  ];

  # tests need a valid home directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "GUI tool to find duplicate files in a system";
    homepage = "https://dupeguru.voltaicideas.net/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ novoxudonoser shamilton ];
    platforms = platforms.linux;
  };
}
