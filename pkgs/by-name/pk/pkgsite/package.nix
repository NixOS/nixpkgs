{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-12-23";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "1a3bd3c788fea11057a8e696fd274c4c3f3e952c";
    hash = "sha256-GnjzJhmH9mOBdpc+r3Hco0KFsTp4LMkbTn/oMBthemQ=";
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
