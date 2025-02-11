{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "lr";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "sha256-TcP0jLFemdmWzGa4/RX7N6xUUTgKsI7IEOD7GfuuPWI=";
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
