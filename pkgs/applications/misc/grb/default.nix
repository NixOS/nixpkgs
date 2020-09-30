{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "grb";
  version = "unstable-2020-02-15";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = pname;
    rev = "e27769a14401b385553b1df7b4cf027bbed0144b";
    sha256 = "1gxg1aj83c7nc272rnxvhadbjadf0fpd4pd4xd2rbwbg80aihh1j";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "Greek Bible on the Command Line";
    homepage = "https://github.com/LukeSmithxyz/grb";
    license = licenses.publicDomain;
    maintainers = [ maintainers.jtobin ];
  };
}

