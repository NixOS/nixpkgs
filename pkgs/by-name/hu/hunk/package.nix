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
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "modem-dev";
    repo = "hunk";
    tag = "v${version}";
    hash = "sha256-PWblqDS86PaSl5ToFawCNGTxmrWcmoBAfq8R5lMDbyk=";
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

    outputHash = "sha256-Ixsv2wXb39kSRck9ZbjJjRlzn4KS2fkfl3v4MEeD7cE=";
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
        'join("node_modules", "hunkdiff", skillRelativePath),' \
        'join("node_modules", "hunkdiff", skillRelativePath),
    join("share", "skills", "hunk", name, "SKILL.md"),'
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
    mkdir -p $out/share/skills/hunk
    cp -R skills/hunk-review skills/hunk-extensions $out/share/skills/hunk/

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
    test -f "$($out/bin/hunk skill path hunk-extensions)"

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
