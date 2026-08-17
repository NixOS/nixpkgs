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
  version = "1.0.0-unstable-2026-06-09";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "opentofu";
    repo = "opentofu-mcp-server";
    rev = "59ee379fff12389a25e75dc26768f8602e505a91";
    hash = "sha256-pPeqlJ/M7ylD7bniVbw/HqsFkZywHISmzpqsQG0VhoU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    pnpm = pnpm_10;
    hash = "sha256-N9+sbSsae1wOmHkOQ1+Km97w7T+BLuZKdskWZs8c4kw=";
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
