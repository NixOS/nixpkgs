{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.5.0-unstable-2026-09-11";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "297fd0acb81d3076a05f67234fece3a833f5fb20";
    hash = "sha256-yr8S7Fl1aSGGf/lep06XqqS1oQok+MH/W/HyJF7CSuY=";
  };

  vendorHash = "sha256-WrZWHk2JpRNJ4wLu6q0zarBwp3pDnEfccO7+DHL5/l0=";

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
