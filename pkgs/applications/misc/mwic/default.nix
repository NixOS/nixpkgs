{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  version = "0.7.2";
  name = "mwic-${version}";

  src = fetchurl {
    url = "https://github.com/jwilk/mwic/releases/download/${version}/${name}.tar.gz";
    sha256 = "1linpagf0i0ggicq02fcvz4rpx7xdpy80ys49wx7fnmz7f3jc6jy";
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

