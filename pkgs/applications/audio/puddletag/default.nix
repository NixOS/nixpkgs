{ stdenv, lib, fetchFromGitHub, pythonPackages, makeWrapper, chromaprint }:

with lib;
with pythonPackages;

buildPythonApplication rec {
  version = "1.1.1";
  name = "puddletag-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "keithgg";
    repo = "puddletag";
    rev = "1.1.1";
    sha256 = "0zmhc01qg64fb825b3kj0mb0r0d9hms30nqvhdks0qnv7ahahqrx";
  };

  sourceRoot = "${name}-src/source";

  disabled = isPy3k;

  outputs = [ "out" ];

  propagatedBuildInputs = [
    chromaprint
    configobj
    mutagen
    pyparsing
    pyqt4
  ];

  doCheck = false;   # there are no tests
  dontStrip = true;  # we are not generating any binaries

  installPhase = ''
    siteDir=$(toPythonPath $out)
    mkdir -p $siteDir
    PYTHONPATH=$PYTHONPATH:$siteDir
    ${python.interpreter} setup.py install --prefix $out
  '';

  meta = with stdenv.lib; {
    homepage = https://puddletag.net;
    description = "An audio tag editor similar to the Windows program, Mp3tag";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
