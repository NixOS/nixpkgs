{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tut";
  version = "0.0.9";

  goPackagePath = "github.com/RasmusLindroth/tut";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "19y6brw1d6dlp2gnkdpbp261662h5j46rmiqg73cxhrlws0y0kfk";
  };

  meta = with stdenv.lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
