{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  installAgentSkills,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

let
  pname = "hunk";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "modem-dev";
    repo = "hunk";
    tag = "v${version}";
    hash = "sha256-dc4/xLAyQe7mL/KMcpjsjgHzgf0tRomQAemVABwUWFY=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out
      find packages -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-hWfG2T3Tfa69nX50OFW5XNRQxMc5lideDEUPw6G26qA=";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    bun
    installAgentSkills
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${node_modules}/. .
    chmod -R u+w node_modules
    find packages -type d -name node_modules -exec chmod -R u+w {} \;

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Entry points mirror upstream's scripts/build/build-bin.ts.
    mkdir -p .bun-tmp .bun-install
    BUN_TMPDIR=$PWD/.bun-tmp \
    BUN_INSTALL=$PWD/.bun-install \
      bun build --compile \
        --no-compile-autoload-bunfig \
        --no-compile-autoload-dotenv \
        packages/hunk/src/main.tsx \
        packages/hunk/src/highlightWorkerEntry.ts \
        --outfile hunk

    runHook postBuild
  '';

  dontInstallAgentSkills = true;
  installPhase = ''
    runHook preInstall

    installBin hunk
    for skill in packages/hunk/skills/*; do
      installSkill "$skill"
    done

    # `hunk skill path` looks for skills/<name>/SKILL.md above the executable.
    ln -s share/skills/${pname} $out/skills

    runHook postInstall
  '';

  dontFixup = true;
  dontStrip = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";

  installCheckPhase = ''
    runHook preInstallCheck

    cmp "$out/share/skills/${pname}/hunk-review/SKILL.md" "$($out/bin/hunk skill path)"
    cmp "$out/share/skills/${pname}/hunk-extensions/SKILL.md" "$($out/bin/hunk skill path hunk-extensions)"

    runHook postInstallCheck
  '';

  passthru = {
    inherit node_modules;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "Terminal diff viewer for agentic changesets";
    homepage = "https://github.com/modem-dev/hunk";
    changelog = "https://github.com/modem-dev/hunk/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "hunk";
    maintainers = with lib.maintainers; [
      MarkusZoppelt
      kaynetik
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
