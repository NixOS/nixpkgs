{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "spirit";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "block";
    repo = "spirit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DJJWqNY5+0oL2KJwGwta55FGvEHA4ICN+vF9zZUznNQ=";
  };

  vendorHash = "sha256-AiNxpUY6zLwa8WlkjG9Em5S1xwCrzX0h4b8DaBth6YE=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/block/spirit";
    description = "Online schema change tool for MySQL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
})
