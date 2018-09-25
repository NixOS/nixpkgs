{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  version = "0.7.6";
  name = "mwic-${version}";

  src = fetchurl {
    url = "https://github.com/jwilk/mwic/releases/download/${version}/${name}.tar.gz";
    sha256 = "0dl56979i54hrmz5l27c4q1f7jd1bpkmi7sm86946dagi4l1ns3i";
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

