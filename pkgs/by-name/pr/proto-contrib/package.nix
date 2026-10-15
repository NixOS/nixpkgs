{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "proto-contrib";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "emicklei";
    repo = "proto-contrib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UwpX6RNFGMxp6myAdX4xMdmg6Cp00oLRe2lfzw6LXU8=";
  };

  vendorHash = "sha256-XAFB+DDWN7CLfNxIBqYJy88gUNrUJYExzy2/BFnBe8c=";

  doCheck = false;

  meta = {
    description = "Contributed tools and other packages on top of the Go proto package";
    homepage = "https://github.com/emicklei/proto-contrib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
})
