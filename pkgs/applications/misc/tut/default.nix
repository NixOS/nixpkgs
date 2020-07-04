{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tut";
  version = "0.0.10";

  goPackagePath = "github.com/RasmusLindroth/tut";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "09l6dmzrvcpix3wg4djs6zk3ql6b6lfhd8z9aglbi6fix4pm8565";
  };

  meta = with stdenv.lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
