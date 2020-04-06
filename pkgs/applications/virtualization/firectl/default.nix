{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "firectl";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "firecracker-microvm";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ni3yx4rjhrkqk2038c6hkb2jwsdj2llx233wd5wgpvb6c57652p";
  };

  modSha256 = "1nqjz1afklcxc3xcpmygjdh3lfxjk6zvmghr8z8fr3nw2wvw2ddr";

  meta = with stdenv.lib; {
    description = "A command-line tool to run Firecracker microVMs";
    homepage = https://github.com/firecracker-microvm/firectl;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
  };
}
