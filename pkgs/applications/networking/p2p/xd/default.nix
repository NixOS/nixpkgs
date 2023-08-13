{ pkgs, buildGoModule, fetchFromGitHub, lib, perl }:

buildGoModule rec {
  pname = "XD";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "majestrate";
    repo = "XD";
    rev = "v${version}";
    sha256 = "sha256-YUstYGIED6ivt+p+aHIK76dLCj+xjytWnZrra49cCi8=";
  };

  vendorHash = "sha256-wO+IICtGVHhrPa1JUwlx+PuNS32FJNKYmboLd3lFl4w=";

  nativeCheckInputs = [ perl ];

  postInstall = ''
    ln -s $out/bin/XD $out/bin/XD-CLI
  '';

  meta = with lib; {
    description = "i2p bittorrent client";
    homepage = "https://xd-torrent.github.io";
    maintainers = with maintainers; [ nixbitcoin ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
