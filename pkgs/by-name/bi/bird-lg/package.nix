{
  buildGoModule,
  fetchFromGitHub,
  lib,
  symlinkJoin,
}:
let
  generic =
    { modRoot, vendorHash }:
    buildGoModule rec {
      pname = "bird-lg-${modRoot}";
      version = "1.3.11";

      src = fetchFromGitHub {
        owner = "xddxdd";
        repo = "bird-lg-go";
        rev = "v${version}";
        hash = "sha256-C0JC8vLLEk+d6vlrtuW7tHj06K7A3HBjKXZ5Nt+2i4I=";
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
    vendorHash = "sha256-kNysGHtOUtYGHDFDlYNzdkCXGUll105Triy4UR7UP0M=";
  };

  bird-lg-proxy = generic {
    modRoot = "proxy";
    vendorHash = "sha256-iosWHHeJyqMPF+Y01+mj70HDKWw0FAZKDpEESAwS/i4=";
  };
in
symlinkJoin {
  name = "bird-lg-${bird-lg-frontend.version}";
  paths = [
    bird-lg-frontend
    bird-lg-proxy
  ];
}
// {
  inherit (bird-lg-frontend) version meta;
}
