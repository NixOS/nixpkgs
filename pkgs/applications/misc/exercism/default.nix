{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

buildGoModule rec {
  pname = "exercism";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "exercism";
    repo  = "cli";
    rev   = "refs/tags/v${version}";
    hash  = "sha256-Mtb5c1/k8kp7bETOSE0X969BV176jpoprr1/mQ3E4Vg=";
  };

  vendorHash = "sha256-fnsSvbuVGRAndU88su2Ck7mV8QBDhxozdmwI3XGtxcA=";

  doCheck = false;

  subPackages = [ "./exercism" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso maintainers.nobbz ];
   mainProgram = "exercism";
  };
}
