{ stdenv, fetchFromBitbucket, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "thonny";
  version = "3.0.1";

  src = fetchFromBitbucket {
    owner = "plas";
    repo = pname;
    rev = "f66bd266deda11534561a01ede53cf1b71d2c3c0";
    sha256 = "0mjskb0gyddybvlbhm10ch1rwzvmci95b018x67bh67bybdl4hm7";
  };

  propagatedBuildInputs = with python3.pkgs; [
    jedi
    pyserial
    tkinter
    docutils
    pylint
    mypy
    pyperclip
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

  meta = with stdenv.lib; {
    description = "Python IDE for beginners";
    longDescription = ''
      Thonny is a Python IDE for beginners. It supports different ways
      of stepping through the code, step-by-step expression
      evaluation, detailed visualization of the call stack and a mode
      for explaining the concepts of references and heap.
    '';
    homepage = https://www.thonny.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
  };
}
