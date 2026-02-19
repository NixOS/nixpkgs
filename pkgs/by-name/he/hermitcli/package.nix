{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "hermit";
  version = "0.49.2";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-RieD6y6ZTTyL5gxEqVxTaGoBwMIFKR7UEYWP2w8XrZU=";
  };

  vendorHash = "sha256-KEwbADLm7oTChoLyx/0SykQX1Fy4bJxNbYcGmfEka7Q=";

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
