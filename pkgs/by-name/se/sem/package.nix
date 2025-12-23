{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sem";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "semaphoreci";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-w9j7Lv8aSTWqH75ttazHjop+B1JbcgSuUIIGbJpR2vc=";
  };

  vendorHash = "sha256-p8+M+pRp12P7tYlFpXjU94JcJOugQpD8rFdowhonh74=";
  subPackages = [ "." ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.buildSource=nix"
  ];

  postInstall = ''
    install -m755 $out/bin/cli $out/bin/sem
  '';

  meta = {
    description = "Cli to operate on semaphore ci (2.0)";
    homepage = "https://github.com/semaphoreci/cli";
    changelog = "https://github.com/semaphoreci/cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
