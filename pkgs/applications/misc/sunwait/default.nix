{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "sunwait";
  version = "2020-10-26";

  src = fetchFromGitHub {
    owner = "risacher";
    repo = "sunwait";
    rev = "102cb417ecbb7a3757ba9ee4b94d6db3225124c4";
    sha256 = "0cs8rdcnzsl10zia2k49a6c2z6gvp5rnf31sgn3hn5c7kgy7l3ax";
  };

  makeFlags = [ "C=${stdenv.cc.targetPrefix}c++" ];

  installPhase = ''
    install -Dm755 sunwait -t $out/bin
  '';

  meta = with lib; {
    description = "Calculates sunrise or sunset times with civil, nautical, astronomical and custom twilights";
    homepage = "https://github.com/risacher/sunwait";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
