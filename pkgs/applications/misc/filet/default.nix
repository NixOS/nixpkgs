{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "filet";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "buffet";
    repo = "filet";
    rev = version;
    sha256 = "0hm7589ih30axafqxhhs4fg1pvfhlqzyzzmfi2ilx8haq5111fsf";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A fucking fucking fast file fucker (afffff)";
    homepage = "https://github.com/buffet/filet";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ buffet ];
    mainProgram = "filet";
  };
}
