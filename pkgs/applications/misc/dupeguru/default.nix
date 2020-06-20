{stdenv, python3Packages, gettext, qt5, fetchFromGitHub}:

python3Packages.buildPythonApplication rec {
  pname = "dupeguru";
  version = "4.0.4";

  format = "other";

  src = fetchFromGitHub {
    owner = "arsenetar";
    repo = "dupeguru";
    rev = "${version}";
    sha256 = "0ma4f1c6vmpz8gi4sdy43x1ik7wh42wayvk1iq520d3i714kfcpy";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gettext
    python3Packages.pyqt5
    qt5.wrapQtAppsHook
  ];

  pythonPath = with python3Packages; [
    pyqt5
    send2trash
    sphinx
    polib
    hsaudiotag3k
  ];

  makeFlags = [
    "PREFIX=${placeholder ''out''}"
    "NO_VENV=1"
  ];

  # TODO: package pytest-monkeyplus for running tests
  # https://github.com/NixOS/nixpkgs/pull/75054/files#r357690123
  doCheck = false;

  # Avoid double wrapping Python programs.
  dontWrapQtApps = true;

  preFixup = ''
    # TODO: A bug in python wrapper
    # see https://github.com/NixOS/nixpkgs/pull/75054#discussion_r357656916
    makeWrapperArgs="''${qtWrapperArgs[@]}"
  '';

  postFixup = ''
    # Executable in $out/bin is a symlink to $out/share/dupeguru/run.py
    # so wrapPythonPrograms hook does not handle it automatically.
    wrapPythonProgramsIn "$out/share/dupeguru" "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    description = "GUI tool to find duplicate files in a system";
    homepage = "https://github.com/arsenetar/dupeguru";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.novoxudonoser ];
  };
}
