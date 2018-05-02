{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  version = "0.7.5";
  name = "mwic-${version}";

  src = fetchurl {
    url = "https://github.com/jwilk/mwic/releases/download/${version}/${name}.tar.gz";
    sha256 = "1b4fz9vs0aihg9nj9aj6d2jmykpa9nxi9rvz06v50wwk515plpmc";
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

