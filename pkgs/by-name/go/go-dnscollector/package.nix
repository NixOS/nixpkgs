{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-dnscollector";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "dmachard";
    repo = "go-dnscollector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UMzL+use4T0WfcbJAW7XKi3ZuSh9ZFRjYcEr+BV9mkc=";
  };

  vendorHash = "sha256-xEtMe9xrdeYDHNLbcVa9INMprF6mEHyyrAt84nUAsUI=";

  subPackages = [ "." ];

  meta = {
    description = "Ingesting, pipelining, and enhancing your DNS logs with usage indicators, security analysis, and additional metadata";
    homepage = "https://github.com/dmachard/go-dnscollector";
    changelog = "https://github.com/dmachard/DNS-collector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shift ];
  };
})
