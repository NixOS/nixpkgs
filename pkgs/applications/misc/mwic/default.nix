{ lib, stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  version = "0.7.9";
  pname = "mwic";

  src = fetchurl {
    url = "https://github.com/jwilk/mwic/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-i7DSvUBUMOvn2aYpwYOCDHKq0nkleknD7k2xopo+C5s=";
  };

  makeFlags=["PREFIX=\${out}"];

  nativeBuildInputs = [
    pythonPackages.wrapPython
  ];

  propagatedBuildInputs = with pythonPackages; [ pyenchant regex ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = "http://jwilk.net/software/mwic";
    description = "spell-checker that groups possible misspellings and shows them in their contexts";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

