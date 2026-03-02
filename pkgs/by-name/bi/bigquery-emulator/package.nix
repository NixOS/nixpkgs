{
  buildGoModule,
  pkgs,
  fetchFromGitHub,
  lib,
}:

buildGoModule.override
  {
    stdenv = pkgs.clangStdenv;
  }
  (finalAttrs: {
    version = "0.6.6";
    pname = "bigquery-emulator";

    src = fetchFromGitHub {
      owner = "goccy";
      repo = "bigquery-emulator";
      tag = "v${finalAttrs.version}";
      hash = "sha256-iAVbxbm1G7FIWTB5g6Ff8h2dZjZssONA2MOCGuvK180=";
    };

    vendorHash = "sha256-TQlsivudutyPFW+3HHX7rYuoB5wafmDTAO1TElO/8pc=";

    postPatch = ''
      # main module does not contain package
      rm -r internal/cmd/generator
    '';

    ldflags = [ "-s -w -X main.version=${finalAttrs.version} -X main.revision=v${finalAttrs.version}" ];

    doCheck = false;

    meta = {
      description = "BigQuery emulator server implemented in Go";
      homepage = "https://github.com/goccy/bigquery-emulator";
      changelog = "https://github.com/goccy/pname/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ tarantoj ];
      mainProgram = "bigquery-emulator";
    };
  })
