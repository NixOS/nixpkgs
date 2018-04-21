{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  version = "0.7.4";
  name = "mwic-${version}";

  src = fetchurl {
    url = "https://github.com/jwilk/mwic/releases/download/${version}/${name}.tar.gz";
    sha256 = "0c0xk7wx4vaamlry6srdixw1q6afmqznvxdzcg1skr0qjypw5i5q";
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
    maintainers = with maintainers; [ ];
  };
}

