{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-dnscollector";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "DNS-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4NtipFqza+KUJ8JDErkrhip22eR5UAc0ZjlWCBWGB1g=";
  };

  vendorHash = "sha256-wKyVLFerCwG14ploz+wHclwaVB1oNm8CW8w1+WaRBaY=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/DNS-collector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
})
