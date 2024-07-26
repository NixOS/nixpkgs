{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fanbox-dl";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${version}";
    hash = "sha256-wMFxAi4ENFFdMwHpgfOp/FRF6h2p91NS94FAjH/C2ww=";
  };

  vendorHash = "sha256-GD5uxa5XWhlHHBztTpDKCTSym2pdkr/or6aGl9qF29U=";

  # pings websites during testing
  doCheck = false;

  meta = with lib; {
    description = "Pixiv FANBOX Downloader";
    mainProgram = "fanbox-dl";
    homepage = "https://github.com/hareku/fanbox-dl";
    license = licenses.mit;
    maintainers = [ maintainers.moni ];
  };
}
