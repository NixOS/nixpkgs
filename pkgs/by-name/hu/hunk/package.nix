{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  pname = "hunk";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "modem-dev";
    repo = "hunk";
    tag = "v${version}";
    hash = "sha256-IkARkW5haVmc+iZPYe22sUi5Ak+egImdrEugtr2O5A4=";
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

    outputHash = "sha256-ueZNCab0yDRgvftao1Wgy8yrcxh1mdnQl6zR237q8WI=";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    bun
    writableTmpDirAsHomeHook
  ];

  # Teach `hunk skill path` to find the FHS layout under share/skills/$pname
  # (https://github.com/NixOS/nixpkgs/issues/547426) instead of $out/skills.
  postPatch = ''
    substituteInPlace src/core/paths.ts \
      --replace-fail \
        'join("node_modules", "hunkdiff", HUNK_REVIEW_SKILL_RELATIVE_PATH),' \
        'join("node_modules", "hunkdiff", HUNK_REVIEW_SKILL_RELATIVE_PATH),
    join("share", "skills", "hunk", "hunk-review", "SKILL.md"),'
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${node_modules}/. .
    chmod -R u+w node_modules
    find packages -type d -name node_modules -exec chmod -R u+w {} \;

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p .bun-tmp .bun-install
    BUN_TMPDIR=$PWD/.bun-tmp \
    BUN_INSTALL=$PWD/.bun-install \
      bun build --compile \
        --no-compile-autoload-bunfig \
        --no-compile-autoload-dotenv \
        src/main.tsx \
        --outfile hunk

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 hunk $out/bin/hunk
    mkdir -p $out/share/skills/hunk/hunk-review
    cp skills/hunk-review/SKILL.md $out/share/skills/hunk/hunk-review/SKILL.md

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

    $out/bin/hunk --version | grep -F ${version}
    test -f "$($out/bin/hunk skill path)"

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
