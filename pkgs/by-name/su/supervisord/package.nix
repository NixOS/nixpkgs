{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "supervisord";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "ochinchina";
    repo = "supervisord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q9D+58xpodWJZUQr5ni6h0Gz/wTKXg94X7h4EAEMG7o=";
  };

  __structuredAttrs = true;

  proxyVendor = true;
  vendorHash = "sha256-3dynMrOMiyc4P2ZCNmCgiyJx1maWIptrMzQr8iYVWCY=";

  preBuild = "go mod tidy";
  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/ochinchina/supervisord";
    description = "Process supervisor tool, rewritten from Python in Golang";
    changelog = "https://github.com/ochinchina/supervisord/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "supervisord";
    maintainers = with lib.maintainers; [ EpicEric ];
    platforms = lib.platforms.linux;
  };
})
