{ stdenv, fetchFromGitHub, python2Packages, makeWrapper, chromaprint }:

let
  pypkgs = python2Packages;

in pypkgs.buildPythonApplication rec {
  name = "puddletag-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "keithgg";
    repo = "puddletag";
    rev = version;
    sha256 = "0zmhc01qg64fb825b3kj0mb0r0d9hms30nqvhdks0qnv7ahahqrx";
  };

  sourceRoot = "${name}-src/source";

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
