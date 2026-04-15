{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  nodejs_20,
  nix-update-script,
  patch-package,
}:

buildNpmPackage (finalAttrs: {
  pname = "portkey-gateway";
  version = "1.15.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Portkey-AI";
    repo = "gateway";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uHIUS9qfFLB1iL/NTtAL/11lizxAGCpiT648/0aHSm8=";
  };

  npmDepsHash = "sha256-ooViuZzr2lKk1waVd51+pLO597mCr94tZbvhfpLlMYc=";

  # Upstream targets Node 20.x
  nodejs = nodejs_20;

  nativeBuildInputs = [
    jq
    patch-package
  ];

  # Required for patch-package to modify node_modules
  makeCacheWritable = true;

  # Rewrite bin field so buildNpmPackage auto-generates the wrapper correctly
  # (upstream uses string form which doesn't work well with scoped package names)
  postPatch = ''
    # With __structuredAttrs, npmDeps is a bash variable but not exported,
    # so the prefetch-npm-deps Rust binary can't find it via env::var_os.
    export npmDeps
    ${lib.getExe jq} '.bin = {"portkey-gateway": "build/start-server.js"}' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  # Apply upstream's patch-package patches to node_modules
  postConfigure = ''
    patch-package
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast AI gateway for routing to 200+ LLMs with one fast and friendly API";
    homepage = "https://github.com/Portkey-AI/gateway";
    changelog = "https://github.com/Portkey-AI/gateway/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "portkey-gateway";
    maintainers = with lib.maintainers; [ trishtzy ];
  };
})
