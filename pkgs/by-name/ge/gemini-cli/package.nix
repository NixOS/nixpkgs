{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  pkg-config,
  makeWrapper,
  clang_20,
  libsecret,
  ripgrep,
  nodejs_22,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  version = "0.38.1";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iq/KxQ8rbLtXDbGzcZxspfFwar189H3mBWwOD4hO7HU=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-T3fxNFvkLR7f49GQjzzTnl3VM+VUUgJfFF5d2GGe7L4=";

  dontPatchElf = stdenv.hostPlatform.isDarwin;

  nativeBuildInputs = [
    jq
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ clang_20 ]; # clang_21 breaks @vscode/vsce's optionalDependencies keytar

  buildInputs = [
    ripgrep
    libsecret
  ];

  preConfigure = ''
    mkdir -p packages/generated
    echo "export const GIT_COMMIT_INFO = { commitHash: '${finalAttrs.src.rev}' };" > packages/generated/git-commit.ts
  '';

  postPatch = ''
    # Remove node-pty dependency from package.json
    ${jq}/bin/jq 'del(.optionalDependencies."node-pty")' package.json > package.json.tmp && mv package.json.tmp package.json

    # Remove node-pty dependency from packages/core/package.json
    ${jq}/bin/jq 'del(.optionalDependencies."node-pty")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json

    # Fix ripgrep path for SearchText; ensureRgPath() on its own may return the path to a dynamically-linked ripgrep binary without required libraries
    substituteInPlace packages/core/src/tools/ripGrep.ts \
      --replace-fail "await ensureRgPath();" "'${lib.getExe ripgrep}';"

    # Disable auto-update by changing default values in settings schema
    sed -i '/enableAutoUpdate:/,/default: true/ s/default: true/default: false/' packages/cli/src/config/settingsSchema.ts
    sed -i '/enableAutoUpdateNotification:/,/default: true/ s/default: true/default: false/' packages/cli/src/config/settingsSchema.ts

    # Also make sure the values are disabled in runtime code by changing condition checks to false
    substituteInPlace packages/cli/src/utils/handleAutoUpdate.ts \
      --replace-fail "if (!settings.merged.general.enableAutoUpdateNotification) {" "if (false) {" \
      --replace-fail "settings.merged.general.enableAutoUpdate," "false," \
      --replace-fail "!settings.merged.general.enableAutoUpdate" "!false"
  '';

  # Prevent npmDeps and python from getting into the closure
  disallowedReferences = [
    finalAttrs.npmDeps
    finalAttrs.nodejs.python
  ];

  npmBuildScript = "bundle";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r bundle $out/share/gemini-cli

    # We only want to keep optionalDependencies (like @lydell/node-pty) to keep the closure size small,
    # as regular dependencies are already bundled via esbuild into gemini.js.
    jq '.dependencies = {} | del(.devDependencies) | del(.workspaces)' package.json > package.json.tmp && mv package.json.tmp package.json
    npm prune --omit=dev
    rm -rf node_modules/.bin

    # keytar/build has gyp-mac-tool with a Python shebang that gets patched,
    # creating a python3 reference in the closure
    find node_modules -path "*/build/*" -type f -not -name "*.node" -delete
    find node_modules -type d -empty -delete

    cp -r node_modules $out/share/gemini-cli/

    rm -f $out/share/gemini-cli/docs/CONTRIBUTING.md

    makeWrapper "${lib.getExe finalAttrs.nodejs}" "$out/bin/gemini" \
      --add-flags "--no-warnings=DEP0040" \
      --add-flags "$out/share/gemini-cli/gemini.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      brantes
      xiaoxiangmoe
      FlameFlag
      taranarmo
      caverav
    ];
    platforms = lib.platforms.all;
    mainProgram = "gemini";
  };
})
