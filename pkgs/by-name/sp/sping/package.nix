{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sping";
  version = "0-unstable-2023-09-19";

  src = fetchFromGitHub {
    owner = "benjojo";
    repo = "sping";
    rev = "287083dd1ec5a2f999656f8f63c2c3284d0610c9";
    hash = "sha256-tkvl0ewHpnbxCD0CZHjZmtdYB2NPntZnyT3L98+ezzg=";
  };

  vendorHash = null;

  meta = {
    description = "split-ping can tell you what direction packet latency or loss is on";
    homepage = "https://github.com/benjojo/sping";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "sping";
  };
})
