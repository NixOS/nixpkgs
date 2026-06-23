{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  nix-update-script,
  pnpm_8,
  pnpmConfigHook,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentofu-mcp-server";
  version = "1.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "opentofu";
    repo = "opentofu-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qgjAnoduzAjvxgbgG8QW53CMF3/bW0NQhDbVv3ebntw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    pnpm = pnpm_8;
    hash = "sha256-8U+yGjUtgpASLU5LewUMRFT0uxz45trw27+HH/h+sdA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_8
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenTofu MCP server for accessing the OpenTofu Registry";
    homepage = "https://github.com/opentofu/opentofu-mcp-server";
    changelog = "https://github.com/opentofu/opentofu-mcp-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ eana ];
    mainProgram = "opentofu-mcp-server";
  };
})
