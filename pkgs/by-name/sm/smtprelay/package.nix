{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "smtprelay";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "decke";
    repo = "smtprelay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vuK+05+xCO5Bkfs+21a+oqLFHehj1qUvh16ggZQdnrI=";
  };

  vendorHash = "sha256-jriQMYFczhJNbufazWAUFFOrHRnLbo9zzpIrnI0zBkA=";

  subPackages = [
    "."
  ];

  env.CGO_ENABLED = 0;

  # We do not supply the build time as the build wouldn't be reproducible otherwise.
  ldflags = [
    "-s"
    "-w"
    "-X=main.appVersion=v${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/decke/smtprelay";
    description = "Simple Golang SMTP relay/proxy server";
    mainProgram = "smtprelay";
    changelog = "https://github.com/decke/smtprelay/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juliusrickert ];
  };
})
