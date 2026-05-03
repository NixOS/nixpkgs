{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "sem";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "semaphoreci";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-FJn1oTtECPZpBi2LsoAxA2kyS3RY1/5oJGOTZiwitsA=";
  };

  vendorHash = "sha256-XEr/vXamJ7GTRpXNdcVQ9PcUVvQ8EW3pmq/tEZMHSDo=";
  subPackages = [ "." ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.buildSource=nix"
  ];

  postInstall = ''
    install -m755 $out/bin/cli $out/bin/sem
  '';

  meta = {
    description = "Cli to operate on semaphore ci (2.0)";
    homepage = "https://github.com/semaphoreci/cli";
    changelog = "https://github.com/semaphoreci/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
