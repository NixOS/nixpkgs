{
  lib,
  buildGoModule,
  fetchgit,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-twirp_php";
  version = "0.15.0";

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KlUcLsqWsme7OMREv0GjWlEHf5UjiFd6A9MzkbP0Kz4=";
  };

  vendorHash = "sha256-9ZljfwdeM9Ym068P+cJUGh+XOptBOkEOGYK4VpTjccU=";

  subPackages = [ "protoc-gen-twirp_php" ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "PHP port of Twitch's Twirp RPC framework";
    mainProgram = "protoc-gen-twirp_php";
    homepage = "https://github.com/twirphp/twirp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jojosch ];
  };
})
