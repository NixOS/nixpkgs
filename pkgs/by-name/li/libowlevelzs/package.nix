{ cmake
, fetchFromGitHub
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "libowlevelzs";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "fogti";
    repo = "libowlevelzs";
    rev = "v${version}";
    sha256 = "y/EaMMsmJEmnptfjwiat4FC2+iIKlndC2Wdpop3t7vY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Zscheile Lowlevel (utility) library";
    homepage = "https://github.com/fogti/libowlevelzs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
}
