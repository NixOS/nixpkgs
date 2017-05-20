{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  version = "0.7.3";
  name = "mwic-${version}";

  src = fetchurl {
    url = "https://github.com/jwilk/mwic/releases/download/${version}/${name}.tar.gz";
    sha256 = "0baa2pnaba954k169p9rpzc66mhz9zqdd3lz9q95rp9dgygvchzn";
  };

  makeFlags=["PREFIX=\${out}"];

  nativeBuildInputs = [
    pythonPackages.wrapPython
  ];

  propagatedBuildInputs = with pythonPackages; [ pyenchant regex ];

  postFixup = ''
    buildPythonPath "$out"
  '';

  meta = with stdenv.lib; {
    homepage = http://jwilk.net/software/mwic;
    description = "spell-checker that groups possible misspellings and shows them in their contexts";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

