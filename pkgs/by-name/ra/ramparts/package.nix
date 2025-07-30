{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ramparts";
  version = "0.8.10";

  src = fetchFromGitHub {
    owner = "highflame-ai";
    repo = "ramparts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Vmr4JxZFWooIiTIGRIxS93QOOHjsY8qxzm9t1XT5xQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  # Upstream stamps the release version into Cargo.toml only in its release workflow
  postPatch = ''
    sed -i 's|^version = ".*"|version = "${finalAttrs.version}"|' Cargo.toml
  '';

  cargoHash = "sha256-pkkDNR7FoGi62LUoTJ7hIHa9TAw22s5x8c+1phR8EdI=";

  # Server tests probe the spawned server with curl
  nativeCheckInputs = [ curl ];

  # These tests race on the shared LLM_API_KEY environment variable
  checkFlags = [ "--skip=integration_tests::tests::test_env" ];

  __darwinAllowLocalNetworking = true;

  # Install YARA rules where the binary looks for them relative to itself
  postInstall = ''
    mkdir -p $out/share/ramparts
    cp -r rules $out/share/ramparts/
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Security scanner for Model Context Protocol (MCP) servers and AI agent skills";
    longDescription = ''
      Ramparts scans MCP servers and AI agent skills for indirect attack
      vectors and security or configuration vulnerabilities.
    '';
    homepage = "https://github.com/highflame-ai/ramparts";
    changelog = "https://github.com/highflame-ai/ramparts/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ramparts";
  };
})
