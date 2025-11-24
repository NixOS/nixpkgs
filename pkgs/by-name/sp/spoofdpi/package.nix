{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "SpoofDPI";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "v${version}";
    hash = "sha256-9HcxZ9SuZMq5D3vCaHWCKZWm9PvGZ1iaj0nSXoZ2bNU=";
  };

  vendorHash = "sha256-NvFqfM+5/2r4jn1Krno5HOnmKTlX0oq/mw2Hnak9Bm0=";

  meta = {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "Simple and fast anti-censorship tool written in Go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
  };
}
