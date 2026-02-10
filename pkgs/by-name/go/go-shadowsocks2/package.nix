{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-shadowsocks2";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "go-shadowsocks2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-z2+5q8XlxMN7x86IOMJ0qbrW4Wrm1gp8GWew51yBRFg=";
  };

  vendorHash = "sha256-RrHksWET5kicbdQ5HRDWhNxx4rTi2zaVeaPoLdg4uQw=";

  meta = {
    description = "Fresh implementation of Shadowsocks in Go";
    homepage = "https://github.com/shadowsocks/go-shadowsocks2/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oxzi ];
    mainProgram = "go-shadowsocks2";
  };
})
