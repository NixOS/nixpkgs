{ lib, fetchFromGitHub, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "thonny";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1pzy7v48x4ip8v6aqm8hl5ywx7xiqbsfypxxifih8gnlangp1n8y";
  };

  propagatedBuildInputs = with python3.pkgs; [
    jedi
    pyserial
    tkinter
    docutils
    pylint
    mypy
    pyperclip
    asttokens
    send2trash
  ];

  preInstall = ''
    export HOME=$(mktemp -d)
  '';

  preFixup = ''
    wrapProgram "$out/bin/thonny" \
       --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath ${python3.pkgs.jedi})
  '';

  # Tests need a DISPLAY
  doCheck = false;

  meta = with lib; {
    description = "Python IDE for beginners";
    longDescription = ''
      Thonny is a Python IDE for beginners. It supports different ways
      of stepping through the code, step-by-step expression
      evaluation, detailed visualization of the call stack and a mode
      for explaining the concepts of references and heap.
    '';
    homepage = "https://www.thonny.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
  };
}
