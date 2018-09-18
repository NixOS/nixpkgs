{ stdenv, fetchFromBitbucket, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "thonny";
  version = "3.0.0b3";

  src = fetchFromBitbucket {
    owner = "plas";
    repo = pname;
    rev = "a511d4539c532b6dddf6d7f1586d30e1ac35bd86";
    sha256 = "1s3pp97r6p3j81idglnml4faxryk7saszxmv3gys1agdfj75qczr";
  };

  propagatedBuildInputs = with python3.pkgs; [ jedi pyserial tkinter docutils pylint ];

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
