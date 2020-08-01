{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "firectl";
  version = "0.1.0";

  patches = [ ./gomod.patch ];

  src = fetchFromGitHub {
    owner = "firecracker-microvm";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ni3yx4rjhrkqk2038c6hkb2jwsdj2llx233wd5wgpvb6c57652p";
  };

  vendorSha256 = "1xbpck1gvzl75xgrajf5yzl199l4f2f6j3mac5586i7b00b9jxqj";

  meta = with stdenv.lib; {
    description = "A command-line tool to run Firecracker microVMs";
    homepage = "https://github.com/firecracker-microvm/firectl";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
  };
}
