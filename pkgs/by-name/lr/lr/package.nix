{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "lr";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "sha256-zpHThIB1FS45RriE214SM9ZQJ1HyuBkBi/+PTeJjEFc=";
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
