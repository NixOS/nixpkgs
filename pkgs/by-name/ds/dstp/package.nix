{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dstp";
  version = "0.4.23";

  src = fetchFromGitHub {
    owner = "ycd";
    repo = "dstp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QODp9IbIc2Z7N/xfRd0UV9r8t6RndOjdGe9hQXJyiN0=";
  };

  vendorHash = "sha256-EE3xSRu7zAuQjaXCdTD924K6OamEkdxHYEaM0rW/O+o=";

  # Tests require network connection, but is not allowed by nix
  doCheck = false;

  meta = {
    description = "Run common networking tests against your site";
    mainProgram = "dstp";
    homepage = "https://github.com/ycd/dstp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
