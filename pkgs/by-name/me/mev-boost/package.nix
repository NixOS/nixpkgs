{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mev-boost";
  version = "1.10.1";
  src = fetchFromGitHub {
    owner = "flashbots";
    repo = "mev-boost";
    rev = "v${version}";
    hash = "sha256-Fm/zeaFJTtevEMZPK0O1QyfF7KXKcpqS2SC3DW7dn3Y=";
  };

  vendorHash = "sha256-FpkQp/PgmZ9+swQYI984j87ODbT0kpanBkHfJK86FWA=";

  meta = {
    description = "Ethereum block-building middleware";
    homepage = "https://github.com/flashbots/mev-boost";
    license = lib.licenses.mit;
    mainProgram = "mev-boost";
    maintainers = with lib.maintainers; [ ekimber ];
    platforms = lib.platforms.unix;
  };
}
