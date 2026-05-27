{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "fanbox-dl";
  version = "0.28.4";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sKvYDrhFuAmJ0+uNgaVH5AB1QwL5pQ6bLQcGPtrt4DU=";
  };

  vendorHash = "sha256-o9/e8IbWN7PzOG60B2IBwVYIWM1qTeYC4EdubdG179s=";

  # pings websites during testing
  doCheck = false;

  meta = {
    description = "Pixiv FANBOX Downloader";
    mainProgram = "fanbox-dl";
    homepage = "https://github.com/hareku/fanbox-dl";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.moni ];
  };
})
