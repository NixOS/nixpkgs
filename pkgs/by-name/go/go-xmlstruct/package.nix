{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-xmlstruct";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "go-xmlstruct";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wkU8YIE3+kuC8g1/qNnW/nLxsDktS2NNTI88GWdwbLw=";
  };

  vendorHash = "sha256-myt5JjEDnLfkYkB+yb/oaH4dgIOB9qFcqcEb6KO5vBk=";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # The --help flag doesn't actually exist in goxmlstruct, causing it to return exit code 2,
    # but this error condition is the only way to get the usage information.
    output=$($out/bin/goxmlstruct --help 2>&1 || true)

    if ! echo "$output" | grep -q "Usage of $out/bin/goxmlstruct:"; then
      echo "Expected usage information not found in output"
      echo "Got: $output"
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Generate Go structs from multiple XML documents";
    mainProgram = "goxmlstruct";
    homepage = "https://github.com/twpayne/go-xmlstruct";
    changelog = "https://github.com/twpayne/go-xmlstruct/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dvcorreia ];
  };
})
