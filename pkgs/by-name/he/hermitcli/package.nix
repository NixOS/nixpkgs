{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "hermit";
  version = "0.52.3";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-bcTj0JR2sAfTPBi5z0s2ZCWu16HYr51JD1qMhA8extE=";
  };

  vendorHash = "sha256-+UIWiP+CvRJQhTS2hMWrb3gB8kEN6fa6xIaYBNUxHOs=";

  subPackages = [ "cmd/hermit" ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.channel=stable"
  ];

  meta = {
    homepage = "https://cashapp.github.io/hermit";
    description = "Manages isolated, self-bootstrapping sets of tools in software projects";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cbrewster ];
    platforms = lib.platforms.unix;
    mainProgram = "hermit";
  };
})
