{ pkgs, buildGoModule, fetchFromGitHub, lib, perl }:

buildGoModule rec {
  pname = "XD";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "majestrate";
    repo = "XD";
    rev = "v${version}";
    sha256 = "sha256-fXENoqhR04TYS/kAJUqsqa0+j+KyzdsMlXIZ2GMPMhc=";
  };

  vendorSha256 = "1wg3cym2rwrhjsqlgd38l8mdq5alccz808465117n3vyga9m35lq";

  checkInputs = [ perl ];

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
