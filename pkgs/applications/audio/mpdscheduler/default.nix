{ fetchFromGitHub, stdenv, buildGoModule }:

buildGoModule rec {
  pname = "mpdscheduler";
  version = "1.0.0";

  rev = "v${version}";
  name = "${pname}-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "AberDerBart";
    repo = "mpdscheduler";
    sha256 = "1fxc416h1hisf3rdnk3h488hbapkmdpxhladbc0v6spgp6ck9y6s";
  };

  vendorSha256 = "19kxvgxx2cdgwpnqjkkfb0xw73hrf5h1486zfgyhpzm1r3rnwv0v";

  goPackagePath = "github.com/AberDerBart/mpdscheduler";

  meta = with stdenv.lib; {
    description = "Adds alarm and sleep timer functionality to mpd";
    maintainers = [ maintainers.aberDerBart ];
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
