{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-dnscollector";
  version = "3.3.8";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "DNS-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IpfNgkx5h/7nIKeiyMaZLxNVCh/hnBk0L8hS6V8EW4w=";
  };

  vendorHash = "sha256-dS8bKG7K2tD7JUq3gLG7J8V8SPccSUjr7KOP8Q/v7g0=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/DNS-collector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
})
