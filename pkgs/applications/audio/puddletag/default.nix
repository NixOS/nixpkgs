{ stdenv, fetchFromGitHub, python2Packages, chromaprint }:

python2Packages.buildPythonApplication rec {
  pname = "puddletag";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner  = "keithgg";
    repo   = "puddletag";
    rev    = "v${version}";
    sha256 = "1g6wa91awy17z5b704yi9kfynnvfm9lkrvpfvwccscr1h8s3qmiz";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */source)
  '';

  disabled = python2Packages.isPy3k; # work to support python 3 has not begun

  propagatedBuildInputs = [ chromaprint ] ++ (with python2Packages; [
    configobj
    mutagen
    pyparsing
    pyqt4
  ]);

  doCheck = false;   # there are no tests
  dontStrip = true;  # we are not generating any binaries

  meta = with stdenv.lib; {
    description = "An audio tag editor similar to the Windows program, Mp3tag";
    homepage    = https://docs.puddletag.net;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.linux;
  };
}
