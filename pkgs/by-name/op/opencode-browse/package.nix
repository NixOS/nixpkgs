{
  lib,
  buildNpmPackage,
  fetchurl,
  jq,
  coreutils,
}:

buildNpmPackage (finalAttrs: {
  pname = "opencode-browse";
  version = "0.0.16";

  __structuredAttrs = true;

  # Upstream publishes a self-contained JavaScript CLI bundle. The
  # Playwright-compatible CDP implementation is still loaded externally.
  src = fetchurl {
    url = "https://registry.npmjs.org/@opencode/browse/-/browse-${finalAttrs.version}.tgz";
    hash = "sha512-DOiguaDF1EovDR/w+4xLmkri5Lpc6DxgUUfVuIxwxt34kWu2HB1uZ5ISlM6YumlGek869K9/ih7Ls2gh7VzDEw==";
  };

  # The npm package ships without a lockfile; this one is generated from the
  # dependency versions pinned by upstream's package.json.
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-vCeHBkEUpa3gg04mm6Dh0f0c10LuGBLT3F/oF2WDPuQ=";

  # The published tarball already contains the built CLI bundle, and the
  # build script requires bun.
  dontNpmBuild = true;

  # buildNpmPackage creates executable wrappers from package.json bin entries.
  makeWrapperArgs = [
    "--set"
    "OPENCODE_BROWSER_AUTO_UPDATE"
    "off"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    jq
    coreutils
  ];
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    test "$("$out/bin/browse" --version)" = "${finalAttrs.version}"
    # The server answers the initialize request but exits non-zero when
    # stdin closes, so only the response content is asserted below.
    printf '%s\n' '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"nixpkgs","version":"1"}}}' \
      | timeout 15 "$out/bin/browse" mcp > "$TMPDIR/initialize.json" || true
    test "$(jq -se 'any(.[]; .id == 1 and .result.serverInfo.name == "browse" and .result.serverInfo.version == "${finalAttrs.version}")' \
      "$TMPDIR/initialize.json")" = true
    runHook postInstallCheck
  '';

  meta = {
    description = "MCP server and CLI for automating a signed-in Chromium browser";
    homepage = "https://github.com/anomalyco/browse";
    changelog = "https://github.com/anomalyco/browse/releases/tag/v${finalAttrs.version}";
    # Browse is MIT; the packaged patchright-core and pixelmatch dependencies
    # are licensed under Apache-2.0 and ISC, respectively.
    license =
      with lib.licenses;
      AND [
        mit
        asl20
        isc
      ];
    maintainers = with lib.maintainers; [ repparw ];
    mainProgram = "browse";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
