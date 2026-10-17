{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ramparts";
  version = "0.8.10";

  src = fetchFromGitHub {
    owner = "getjavelin";
    repo = "ramparts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Vmr4JxZFWooIiTIGRIxS93QOOHjsY8qxzm9t1XT5xQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  cargoHash = "sha256-pkkDNR7FoGi62LUoTJ7hIHa9TAw22s5x8c+1phR8EdI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Server spawned by these tests never becomes healthy in the sandbox
  checkFlags = [
    "--skip=preflight_from_a_browser_origin_is_allowed"
    "--skip=server_boots_with_the_deployed_entrypoint_argv"
  ];

  # Upstream did not bump Cargo.toml, so --version reports 0.8.2
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "mcp (model context protocol) scanner";
    longDescription = ''
      Mcp scan that scans any mcp server for indirect attack vectors
      and security or configuration vulnerabilities.
    '';
    homepage = "https://github.com/getjavelin/ramparts";
    changelog = "https://github.com/getjavelin/ramparts/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ramparts";
  };
})
