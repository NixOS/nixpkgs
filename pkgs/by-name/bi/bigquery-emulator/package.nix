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
    version = "0.8.1";
    pname = "bigquery-emulator";

    src = fetchFromGitHub {
      owner = "goccy";
      repo = "bigquery-emulator";
      tag = "v${finalAttrs.version}";
      hash = "sha256-/IwuXbw1Kaqji3UCTaCmAxZS2ZvX3SABYwjclA2f6eg=";
    };

    vendorHash = "sha256-xfqXW1LukyCLMIl80FsjjhMfEymFnVY3VKtowmE7I4I=";

    postPatch = ''
      # main module does not contain package
      rm -r internal/cmd/generator
    '';

    tags = [
      # grpc uses http2.TrailerPrefix, which x/net only defines on Go 1.27 with http2legacy
      # https://github.com/golang/net/commit/49810da71b9026da9e0d028a6ad8c7730c52d9c4
      # https://github.com/grpc/grpc-go/issues/9206
      # Drop once upstream bumps x/net: https://github.com/goccy/bigquery-emulator/pull/497
      "http2legacy"
    ];

    ldflags = [ "-s -w -X main.version=${finalAttrs.version} -X main.revision=v${finalAttrs.version}" ];

    doCheck = false;

    meta = {
      description = "BigQuery emulator server implemented in Go";
      homepage = "https://github.com/goccy/bigquery-emulator";
      changelog = "https://github.com/goccy/bigquery-emulator/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ tarantoj ];
      mainProgram = "bigquery-emulator";
    };
  })
