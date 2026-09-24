{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentofu-mcp-server";
  version = "1.0.0-unstable-2026-07-15";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "opentofu";
    repo = "opentofu-mcp-server";
    rev = "ad9e50780d8ae56ee9a71ddea5f3f8c8f2da1020";
    hash = "sha256-bp1tY4ggHVSVFcU+b/TlWBHhjmrf32Q3a86GWgvkFOk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    pnpm = pnpm_10;
    hash = "sha256-7GEO4Mzxo7k7LXtCaLzF++4iEvc1kFw6uF9LywfPcdo=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/opentofu-mcp-server
    cp -r dist node_modules $out/lib/opentofu-mcp-server/
    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/opentofu-mcp-server \
      --add-flags "$out/lib/opentofu-mcp-server/dist/local.js"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "OpenTofu MCP server for accessing the OpenTofu Registry";
    homepage = "https://github.com/opentofu/opentofu-mcp-server";
    changelog = "https://github.com/opentofu/opentofu-mcp-server/commits/main";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ eana ];
    mainProgram = "opentofu-mcp-server";
  };
})
