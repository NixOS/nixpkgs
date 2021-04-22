{ lib
, buildPythonApplication
, fetchFromGitHub
, wrapQtAppsHook
, gettext
, hsaudiotag3k
, polib
, pyqt5
, send2trash
, sip
, sphinx
, black
, distro
, flake8
, pytest
, tox
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
    fetchSubmodules = true;
  };

  patches = [ ./tox-passenv-PYTHONPATH.patch ];

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

  # TODO: A bug in python wrapper
  # see https://github.com/NixOS/nixpkgs/pull/75054#discussion_r357656916
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
    black
    distro
    flake8
    pytest
    send2trash
    tox
  ];

  checkPhase = ''
    tox
  '';

  meta = with lib; {
    description = "GUI tool to find duplicate files in a system";
    homepage = "https://dupeguru.voltaicideas.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ novoxudonoser shamilton ];
  };
}
