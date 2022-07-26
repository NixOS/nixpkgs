{ stdenv, lib, python3Packages, gettext, qt5, fetchFromGitHub}:

python3Packages.buildPythonApplication rec {
  pname = "dupeguru";
  version = "4.1.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "arsenetar";
    repo = "dupeguru";
    rev = version;
    sha256 = "sha256-0lJocrNQHTrpslbPE6xjZDWhzza8cAt2js35LvicZKg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gettext
    python3Packages.pyqt5
    qt5.wrapQtAppsHook
  ];

  pythonPath = with python3Packages; [
    pyqt5
    pyqt5_sip
    send2trash
    sphinx
    polib
    hsaudiotag3k
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "NO_VENV=1"
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  # Avoid double wrapping Python programs.
  dontWrapQtApps = true;

  # TODO: A bug in python wrapper
  # see https://github.com/NixOS/nixpkgs/pull/75054#discussion_r357656916
  preFixup = ''
    makeWrapperArgs="''${qtWrapperArgs[@]}"
  '';

  # Executable in $out/bin is a symlink to $out/share/dupeguru/run.py
  # so wrapPythonPrograms hook does not handle it automatically.
  postFixup = ''
    wrapPythonProgramsIn "$out/share/dupeguru" "$out $pythonPath"
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "GUI tool to find duplicate files in a system";
    homepage = "https://github.com/arsenetar/dupeguru";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.novoxd ];
  };
}
