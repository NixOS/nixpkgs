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
  version = "0.66.0";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oVxwZU5Kmb+9e0WSBouqSgNdCDyT9W7tT1XiaaA5zRg=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-E5dN6qo3E4XI6hbmJ8+PHHnWLpBCZMr9Zv8g+N1ekCk=";

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

    # package-lock.json installs versions that these exact pins reject, so npm tries to
    # fetch the pinned versions, which the offline cache lacks. Pin what the lock installs.
    # https://github.com/google-gemini/gemini-cli/issues/29820
    for pin in \
      cli:dependencies:tar:7.5.11 \
      a2a-server:dependencies:tar:7.5.11 \
      cli:dependencies:clipboardy:5.2.1 \
      a2a-server:devDependencies:vitest:3.1.1 \
      sdk:devDependencies:vitest:3.1.1 \
      vscode-ide-companion:devDependencies:typescript:5.9.3; do
      IFS=: read -r ws section name version <<< "$pin"
      ${jq}/bin/jq --arg s "$section" --arg n "$name" --arg v "$version" \
        '.[$s][$n] = $v' packages/$ws/package.json > package.json.tmp
      mv package.json.tmp packages/$ws/package.json
      ${jq}/bin/jq --arg w "packages/$ws" --arg s "$section" --arg n "$name" --arg v "$version" \
        '.packages[$w][$s][$n] = $v' package-lock.json > package-lock.json.tmp
      mv package-lock.json.tmp package-lock.json
    done

    # Prefer the Nix ripgrep binary by prepending it to candidate paths
    substituteInPlace packages/core/src/tools/ripGrep.ts \
      --replace-fail "const candidatePaths = [" "const candidatePaths = [\"${lib.getExe ripgrep}\", "

    # Trust the Nix store path by adding it to standard system prefixes
    substituteInPlace packages/core/src/utils/paths.ts \
      --replace-fail "const trustedPrefixes = [" "const trustedPrefixes = [\"/nix/store\", "

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
    problems.removal = {
      message = "Unpaid tier and Google AI Pro/Ultra users: Gemini CLI was replaced by Antigravity CLI.";
      urls = [
        "https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/"
      ];
    };
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      caverav
    ];
    platforms = lib.platforms.all;
    mainProgram = "gemini";
  };
})
