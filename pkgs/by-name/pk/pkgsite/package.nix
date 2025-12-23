{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-12-15";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "4eb0af2c34bf5ae5d7e04cc47cd8f7b6269ef079";
    hash = "sha256-BpNB8wrb3vR5NXAxwRfrQjwcSllWB1YlQJU25OlS8Hw=";
  };

  vendorHash = "sha256-6wgJNDzUzSCkwzjqGwzpa63+0HoN5PapKxMBFBuu16M=";

  subPackages = [ "cmd/pkgsite" ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Official tool to extract and generate documentation for Go projects like pkg.go.dev";
    homepage = "https://github.com/golang/pkgsite";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "pkgsite";
  };
}
