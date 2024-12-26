{
  buildGoModule,
  pkgs,
  fetchFromGitHub,
  lib,
}:
let
  version = "0.6.6";
  pname = "bigquery-emulator";
in
buildGoModule.override
  {
    stdenv = pkgs.clangStdenv;
  }
  {
    name = pname;

    src = fetchFromGitHub {
      owner = "goccy";
      repo = "bigquery-emulator";
      rev = "refs/tags/v${version}";
      hash = "sha256-iAVbxbm1G7FIWTB5g6Ff8h2dZjZssONA2MOCGuvK180=";
    };

    vendorHash = "sha256-TQlsivudutyPFW+3HHX7rYuoB5wafmDTAO1TElO/8pc=";

    postPatch = ''
      # main module does not contain package
      rm -r internal/cmd/generator
    '';

    ldflags = [ "-s -w -X main.version=${version} -X main.revision=v${version}" ];

    doCheck = false;

    meta = with lib; {
      description = "BigQuery emulator server implemented in Go.";
      homepage = "https://github.com/goccy/bigquery-emulator";
      changelog = "https://github.com/goccy/pname/releases/tag/v${version}";
      license = licenses.mit;
      maintainers = with maintainers; [ tarantoj ];
      mainProgram = "bigquery-emulator";
    };
  }
