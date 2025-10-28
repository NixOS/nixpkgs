{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "go-jsonschema";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "omissis";
    repo = "go-jsonschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e1eL5Blf9l4cSR7Tg740eTFza3ViJEiwLaoUsUZzQu4=";
  };

  vendorHash = "sha256-vHtigJ2YNFFWGxv6/pGwmmGE0Fn+2S7NguyrhVME7ak=";

  ldflags = [
    "-X main.version=v${finalAttrs.version}"
    "-s"
    "-w"
  ];

  env.GOWORK = "off";

  # Tests are in a nested Go module which makes things difficult.
  preBuild = ''
    rm -rf tests
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to generate Go data types from JSON Schema definitions";
    homepage = "https://github.com/omissis/go-jsonschema";
    changelog = "https://github.com/omissis/go-jsonschema/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      shellhazard
    ];
    mainProgram = "go-jsonschema";
  };
})
