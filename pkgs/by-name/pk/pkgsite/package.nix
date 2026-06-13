{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.1.0-unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "deb78785c3ce936751c393f7eb5079a9ad63d841";
    hash = "sha256-3K4O59BtJfDyiUKQ/OA20FLb/9LGyiutn6ULeiDFQ6g=";
  };

  vendorHash = "sha256-jMHGQrGQjNsWNj7BnhRYDn17W+6VI3A940AkR4Rmvok=";

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
