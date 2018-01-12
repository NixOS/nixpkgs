{ stdenv, fetchFromGitHub, python2Packages, makeWrapper, chromaprint }:

python2Packages.buildPythonApplication rec {
  name = "puddletag-${version}";
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

  installPhase = ''
    runHook preInstall

    siteDir=$(toPythonPath $out)
    mkdir -p $siteDir
    PYTHONPATH=$PYTHONPATH:$siteDir
    ${python2Packages.python.interpreter} setup.py install --prefix $out

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage    = https://puddletag.net;
    description = "An audio tag editor similar to the Windows program, Mp3tag";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.linux;
  };
}
