{ pkgs, buildGoModule, fetchFromGitHub, lib, perl }:

buildGoModule rec {
  pname = "XD";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "majestrate";
    repo = "XD";
    rev = "v${version}";
    sha256 = "sha256-AavNiFZlpX6XZQLP1kl9igA833i0gxOTYGubo3MvpSU=";
  };

  vendorSha256 = "sha256-mJZRk3p+D3tCKIYggD5jVBXcKqJotEexljDzLKpn4/E=";

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
