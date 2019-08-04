{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "countdown-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/antonmedv/countdown";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "countdown";
    rev = "v${version}";
    sha256 = "0pdaw1krr0bsl4amhwx03v2b02iznvwvqn7af5zp4fkzjaj14cdw";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/antonmedv/countdown;
    description = "Terminal countdown timer";
    maintainers = with maintainers; [ monotux ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
