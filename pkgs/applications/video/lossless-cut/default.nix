{ stdenv, fetchFromGitHub, mkYarnPackage }:

mkYarnPackage rec {
  name = "lossless-cut";
  version = "3.23.7";

  src = fetchFromGitHub {
    owner = "mifi";
    repo = name;
    rev = "v${version}";
    sha256 = "14vfmidj0m11vd1asghmcxwj102c468n6wb4swagnjzrxqh22xa3";
  };

  meta = with stdenv.lib; {
    description = "The swiss army knife of lossless video/audio editing";
    license = licenses.mit;
    homepage = "https://mifi.no/losslesscut";
    maintainers = with maintainers; [ ShamrockLee ];
    platforms = platforms.all;
  };
}
