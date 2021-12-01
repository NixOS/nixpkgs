{ lib, stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  version = "0.7.8";
  pname = "mwic";

  src = fetchurl {
    url = "https://github.com/jwilk/mwic/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0nnhziz9v523hpciylnxfajmxabh2ig5iawzwrfpf7aww70v330x";
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

