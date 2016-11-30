{ stdenv, fetchFromGitHub, python2Packages, makeWrapper, chromaprint }:

let
  pypkgs = python2Packages;
  pname = "puddletag";

in pypkgs.buildPythonApplication rec {
  name = "${pname}-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "keithgg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g6wa91awy17z5b704yi9kfynnvfm9lkrvpfvwccscr1h8s3qmiz";
  };

  sourceRoot = "${pname}-v${version}-src/source";

  disabled = pypkgs.isPy3k; # work to support python 3 has not begun

  outputs = [ "out" ];

  propagatedBuildInputs = [ chromaprint ] ++ (with pypkgs; [
    configobj
    mutagen
    pyparsing
    pyqt4
  ]);

  doCheck = false;   # there are no tests
  dontStrip = true;  # we are not generating any binaries

  installPhase = ''
    siteDir=$(toPythonPath $out)
    mkdir -p $siteDir
    PYTHONPATH=$PYTHONPATH:$siteDir
    ${pypkgs.python.interpreter} setup.py install --prefix $out
  '';

  meta = with stdenv.lib; {
    homepage = https://puddletag.net;
    description = "An audio tag editor similar to the Windows program, Mp3tag";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
