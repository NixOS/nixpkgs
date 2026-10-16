{
  lib,
  nix-update-script,
  stdenvNoCC,
  fetchFromGitHub,
  deno,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "steady";
  version = "0.22.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dgellow";
    repo = "steady";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cUVH9jJwFi9Jm8vYvrYbRCNBS88adReqC4ByKKQhou8=";

    nativeBuildInputs = [ deno ];
    postFetch = ''
      cd "$out"
      export DENO_DIR="$TMPDIR/deno"
      deno install --entrypoint --vendor --frozen cmd/steady.ts

      # The lockfile pins versions; discard mutable registry version lists.
      for manifest in vendor/jsr.io/@*/*/meta.json; do
        echo '{"versions":{}}' > "$manifest"
      done
    '';
  };

  nativeBuildInputs = [ deno ];

  buildPhase = ''
    runHook preBuild
    export DENO_DIR="$TMPDIR/deno"
    export DENORT_BIN="${deno.denort}/bin/denort"
    deno compile --vendor --frozen --cached-only --no-code-cache \
      --allow-read --allow-write --allow-net --allow-env \
      --output steady cmd/steady.ts
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 steady "$out/bin/steady"
    runHook postInstall
  '';

  # Stripping would remove the JavaScript embedded in the Deno executable.
  dontStrip = true;

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenAPI mock server with request validation and response generation";
    homepage = "https://github.com/dgellow/steady";
    changelog = "https://github.com/dgellow/steady/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ munksgaard ];
    mainProgram = "steady";
    inherit (deno.meta) platforms;
  };
})
