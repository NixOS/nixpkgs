{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  jq,
  coreutils,
}:

let
  # The Rust CLI is published as one native npm package per platform.
  # The @opencode/browse npm package is now only a Node.js launcher.
  targets = {
    x86_64-linux = {
      name = "linux-x64";
      hash = "sha512-N0dEMW6hBj8Duzv9lF51uHMUg9TAsJGElJ+NMHMK+yl0rW2PGVc44Lsk4rICe2ctXBHvIdbzQybjTvbGdXXyiQ==";
    };
    aarch64-linux = {
      name = "linux-arm64";
      hash = "sha512-klF2M7mElXniJQ4pDwhtg6m/8FgAx+EDoWzuNN8QlfA/gtYqrG1Hl2j5DsRXxF0s2JrhdJr/Zld9Q2rg8Ncc2Q==";
    };
    x86_64-darwin = {
      name = "darwin-x64";
      hash = "sha512-8wsSqYMW0GWXiURTd5puvPG3rmE2aCnbx6fkT/P9TobYfQ1bGu3K7RgLD0wak4UslzZTNCgYVZhwFhT/jqQ6kA==";
    };
    aarch64-darwin = {
      name = "darwin-arm64";
      hash = "sha512-1fIzN9OrxqD3ZGQ0n7K+iZgRQWIZrUZIsma5FWvSi4haWB1QumsmRNfh1kaRzSOsthn863RbUQvLsplO2KAv2g==";
    };
  };
  target = targets.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencode-browse";
  version = "0.1.1";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://registry.npmjs.org/@opencode/browse-${target.name}/-/browse-${target.name}-${finalAttrs.version}.tgz";
    inherit (target) hash;
  };

  sourceRoot = "package";
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    jq
    coreutils
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/browse "$out/bin/browse"
    runHook postInstall
  '';

  # Nix owns updates; do not let the upstream updater replace this binary.
  postFixup = ''
    wrapProgram "$out/bin/browse" --set OPENCODE_BROWSER_AUTO_UPDATE off
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    test "$("$out/bin/browse" --version)" = "${finalAttrs.version}"
    status=0
    printf '%s\n' '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"nixpkgs","version":"1"}}}' \
      | timeout 15 "$out/bin/browse" mcp > "$TMPDIR/initialize.json" || status=$?
    test "$status" -eq 0 || test "$status" -eq 130
    jq -se 'any(.[]; .id == 1 and .result.serverInfo.name == "browse" and .result.serverInfo.version == "${finalAttrs.version}")' \
      "$TMPDIR/initialize.json"
    runHook postInstallCheck
  '';

  meta = {
    description = "MCP server and CLI for automating a signed-in Chromium browser";
    homepage = "https://github.com/anomalyco/browse";
    changelog = "https://github.com/anomalyco/browse/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ repparw ];
    mainProgram = "browse";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames targets;
  };
})
