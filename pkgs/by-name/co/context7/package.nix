{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,

  nodejs,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
}:
let
  tag-prefix = "@upstash/context7-mcp@";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "context7";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    tag = tag-prefix + finalAttrs.version;
    hash = "sha256-sz26L/iHZ36B02TX3RRUfMXb++i90gzDLwrTXMYZwg8=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-ntbX2rKg+FXChWHLUdRnKr2TeEuWXouzALeHm1FLsHw=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/context7/packages/mcp $out/bin

    cp -r node_modules $out/lib/context7/node_modules
    find $out/lib/context7/node_modules -xtype l -delete

    cp -r packages/mcp/node_modules $out/lib/context7/packages/mcp/node_modules

    cp -r packages/mcp/dist $out/lib/context7/packages/mcp/dist
    cp packages/mcp/package.json $out/lib/context7/packages/mcp/package.json

    makeWrapper ${nodejs}/bin/node $out/bin/context7-mcp \
      --add-flags "$out/lib/context7/packages/mcp/dist/index.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "'${tag-prefix}(.*)'"
    ];
  };

  meta = {
    description = "MCP Server for up-to-date code documentation for LLMs and AI code editors";
    homepage = "https://context7.com/";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ arunoruto ];
    mainProgram = "context7-mcp";
  };
})
