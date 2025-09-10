{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "lr";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "sha256-riKXHcpVb5qe9UOEAAZ8+kjSylYRKRrdiwAB43Y4aRY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/chneukirchen/lr";
    description = "List files recursively";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vikanezrimaya ];
    mainProgram = "lr";
  };
}
