{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  symlinkJoin,
}:
let
  generic =
    { modRoot, vendorHash }:
    buildGoModule rec {
      pname = "bird-lg-${modRoot}";
      version = "1.4.7";

      src = fetchFromGitHub {
        owner = "xddxdd";
        repo = "bird-lg-go";
        rev = "v${version}";
        hash = "sha256-Ca+wMiIMcknqhn+p8Cb00ibvsrsFXyFxvGhqOWrzZcA=";
      };

      doDist = false;

      ldflags = [
        "-s"
        "-w"
      ];

      inherit modRoot vendorHash;

      meta = {
        description = "Bird Looking Glass";
        homepage = "https://github.com/xddxdd/bird-lg-go";
        changelog = "https://github.com/xddxdd/bird-lg-go/releases/tag/v${version}";
        license = lib.licenses.gpl3Plus;
        maintainers = with lib.maintainers; [
          tchekda
          e1mo
        ];
      };
    };

  bird-lg-frontend = generic {
    modRoot = "frontend";
    vendorHash = "sha256-SmpCCvOP9HQh+Niqa3EhRGj1a7EXQgwRW2hTJgv+oIw=";
  };

  bird-lg-proxy = generic {
    modRoot = "proxy";
    vendorHash = "sha256-LRj5OvCu0e0iNW8nEUmbnKhhvaUXOVNIYGv0Lmai28g=";
  };
in
symlinkJoin {
  pname = "bird-lg";
  inherit (bird-lg-frontend) version meta src;
  paths = [
    bird-lg-frontend
    bird-lg-proxy
  ];
  passthru = {
    inherit bird-lg-frontend bird-lg-proxy;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "bird-lg-frontend"
        "--subpackage"
        "bird-lg-proxy"
      ];
    };
  };
}
