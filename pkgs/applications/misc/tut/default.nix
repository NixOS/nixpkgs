{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tut";
  version = "0.0.7";

  goPackagePath = "github.com/RasmusLindroth/tut";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "1v1cvdsrxz1yj2vibx3iapw17ngfihjkr62zhxsn1msb77xyd7lb";
  };

  meta = with stdenv.lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
