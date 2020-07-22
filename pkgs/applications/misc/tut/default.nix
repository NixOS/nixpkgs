{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tut";
  version = "0.0.13";

  goPackagePath = "github.com/RasmusLindroth/tut";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "085qiv9q2hzv1v6qmbddra23acsmmkbwmjqc3cp81gfgl893z7sm";
  };

  meta = with stdenv.lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
