{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule (finalAttrs: {
  pname = "dcrd";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-EzNohMu0jLhQJwI16xKupH/riLKvtC1edMw5l6Bxj/I=";
  };

  vendorHash = "sha256-iUfTHzwjG+TyaHyhs4MGBCvfxah+Wv1+syFkiiaMLeU=";

  subPackages = [
    "."
    "cmd/promptsecret"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export DCRD_APPDATA="$TMPDIR"
  '';

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
})
