{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  ripgrep,
  makeBinaryWrapper,
}:
buildNpmPackage (finalAttrs: {
  pname = "pi-coding-agent";
  version = "0.75.3";

  src = fetchFromGitHub {
    owner = "earendil-works";
    repo = "pi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c/+cxkp/EZ2PLERxTENN5edXHEs7M2oqzNepjRA4TIE=";
  };

  npmDepsHash = "sha256-/mWjrZFzRmtkbWYMJOXKnLPxFITFndq5hgdY0DnPfAg=";

  npmWorkspace = "packages/coding-agent";

  # Skip native module rebuild for unneeded workspaces (e.g. canvas from web-ui)
  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  # Build workspace dependencies in order, then the coding-agent.
  # We invoke tsgo directly for workspace deps to skip pi-ai's
  # generate-models script which requires network access
  # (models.generated.ts is committed to the repo).
  buildPhase = ''
    runHook preBuild

    npx tsgo -p packages/ai/tsconfig.build.json
    npx tsgo -p packages/tui/tsconfig.build.json
    npx tsgo -p packages/agent/tsconfig.build.json
    npm run build --workspace=packages/coding-agent

    runHook postBuild
  '';

  # npm workspace symlinks in the output point into packages/ which
  # doesn't exist there. Replace runtime deps with built content and
  # delete the rest.
  postInstall = ''
    local nm="$out/lib/node_modules/pi-monorepo/node_modules"

    # Replace workspace deps needed at runtime with real copies
    for ws in @earendil-works/pi-ai:packages/ai \
              @earendil-works/pi-agent-core:packages/agent \
              @earendil-works/pi-tui:packages/tui; do
      IFS=: read -r pkg src <<< "$ws"
      rm "$nm/$pkg"
      cp -r "$src" "$nm/$pkg"
    done

    # Delete remaining workspace symlinks
    find "$nm" -type l -lname '*/packages/*' -delete

    # Clean up now-dangling .bin symlinks
    find "$nm/.bin" -xtype l -delete
  '';
  postFixup = "wrapProgram $out/bin/pi --prefix PATH : ${lib.makeBinPath [ ripgrep ]}";

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgram = "${placeholder "out"}/bin/pi";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Coding agent CLI with read, bash, edit, write tools and session management";
    homepage = "https://pi.dev/";
    downloadPage = "https://www.npmjs.com/package/@earendil-works/pi-coding-agent";
    changelog = "https://github.com/earendil-works/pi/blob/main/packages/coding-agent/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ munksgaard ];
    mainProgram = "pi";
  };
})
