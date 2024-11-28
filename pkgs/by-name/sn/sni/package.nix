{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libayatana-appindicator,
  gtk3,
  pkg-config,
}:

buildGoModule rec {
  pname = "sni";
  version = "0.0.98";

  src = fetchFromGitHub {
    owner = "alttpo";
    repo = "sni";
    rev = "refs/tags/v${version}";
    hash = "sha256-UwNWsmydhv6uOJijq5y8PIaDUxO+VSa0gu90gbp0MVw=";
  };

  vendorHash = "sha256-5qdNOUUlHILjJnRkcw58ZvDx1RMi1luWsBGcxyDCW3U=";

  buildInputs = [
    libayatana-appindicator
    gtk3
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  subPackages = [ "cmd/sni" ];

  meta = {
    changelog = "https://github.com/alttpo/sni/releases/tag/v${version}";
    description = "SNES Interface with gRPC API";
    homepage = "https://github.com/alttpo/sni";
    license = lib.licenses.mit;
    mainProgram = "sni";
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
