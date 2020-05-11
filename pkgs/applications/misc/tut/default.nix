{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tut";
  version = "0.0.8";

  goPackagePath = "github.com/RasmusLindroth/tut";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "0wb5lf0zbhmg962p71bqlpyxn8f1n9fp1jh7y7fcg6w5mga8gqq3";
  };

  meta = with stdenv.lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
