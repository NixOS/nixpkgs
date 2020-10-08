{ stdenv, fetchFromGitHub, python3Packages, chromaprint }:

python3Packages.buildPythonApplication rec {
  pname = "puddletag";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "keithgg";
    repo = "puddletag";
    rev = version;
    sha256 = "sha256-9l8Pc77MX5zFkOqU00HFS8//3Bzd2OMnVV1brmWsNAQ=";
  };

  sourceRoot = "source/source";

  propagatedBuildInputs = [ chromaprint ] ++ (with python3Packages; [
    configobj
    mutagen
    pyparsing
    pyqt5
  ]);

  doCheck = false;   # there are no tests

  dontStrip = true;  # we are not generating any binaries

  meta = with stdenv.lib; {
    description = "An audio tag editor similar to the Windows program, Mp3tag";
    homepage = "https://docs.puddletag.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    broken = true; # Needs Qt wrapping
  };
}
