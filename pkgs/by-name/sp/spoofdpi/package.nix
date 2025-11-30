{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "SpoofDPI";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "v${version}";
    hash = "sha256-2rbv81dDXZwXCnO21ol5lqH8i6aSbjrBtGDK0PeNNWA=";
  };

  vendorHash = "sha256-NvFqfM+5/2r4jn1Krno5HOnmKTlX0oq/mw2Hnak9Bm0=";

  meta = {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "Simple and fast anti-censorship tool written in Go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
  };
}
