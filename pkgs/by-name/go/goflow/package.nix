{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "goflow";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "goflow";
    rev = "v${version}";
    sha256 = "sha256-dNu/z48wzUExGsfpKSWmLwhtqbs/Xi+4PFKRjTxt9DI=";
  };

  vendorHash = "sha256-8Vz6zNxFAFjg6VGYaoYbFEp+fJXu3jrC7HJFxdQRkjw=";

  meta = with lib; {
    description = "NetFlow/IPFIX/sFlow collector in Go";
    homepage = "https://github.com/cloudflare/goflow";
    license = licenses.bsd3;
    maintainers = with maintainers; [ heph2 ];
    platforms = platforms.all;
  };
}
