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
      version = "1.3.8";

      src = fetchFromGitHub {
        owner = "xddxdd";
        repo = "bird-lg-go";
        rev = "v${version}";
        hash = "sha256-j81cfHqXNsTM93ofxXz+smkjN8OdJXxtm9z5LdzC+r8=";
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
    vendorHash = "sha256-luJuIZ0xN8mdtWwTlfEDnAwMgt+Tzxlk2ZIDPIwHpcY=";
  };

  bird-lg-proxy = generic {
    modRoot = "proxy";
    vendorHash = "sha256-OVyfPmLTHV5RFdLgRHEH/GqxuG5MnGt9Koz0DxpSg+4=";
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
