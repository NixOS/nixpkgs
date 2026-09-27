{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "goflow";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "goflow";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-dNu/z48wzUExGsfpKSWmLwhtqbs/Xi+4PFKRjTxt9DI=";
  };

  vendorHash = "sha256-8Vz6zNxFAFjg6VGYaoYbFEp+fJXu3jrC7HJFxdQRkjw=";

  meta = {
    description = "NetFlow/IPFIX/sFlow collector in Go";
    homepage = "https://github.com/cloudflare/goflow";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ heph2 ];
    platforms = lib.platforms.all;
  };
})
