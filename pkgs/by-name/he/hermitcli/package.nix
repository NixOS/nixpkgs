{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "hermit";
  version = "0.47.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-VAAdsZ3ZFY+BrH5KDERngxX5xp8CckcnlpSLq4XWU2s=";
  };

  vendorHash = "sha256-KEwbADLm7oTChoLyx/0SykQX1Fy4bJxNbYcGmfEka7Q=";

  subPackages = [ "cmd/hermit" ];

  ldflags = [
    "-X main.version=${version}"
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
}
