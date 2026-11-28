{
  lib,
  stdenv,
  bun,
  callPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  zig_0_17,
  versionCheckHook,
}:

let
  version = "20261101T231906Z-adecbb191a40";
  commit = "adecbb191a4034d332de628787ac8f8b4a1ebcc8";
  src = fetchFromGitHub {
    owner = "tals";
    repo = "corgi";
    tag = version;
    hash = "sha256-CrprlrvOw1Q3wZiJjl8kay2JPnqB+Q/k9FNyaBEk6iY=";
  };

  deps = callPackage ./build.zig.zon.nix { };
  zigForks = lib.concatMapStrings (p: ''"--fork=fork-${p}", '') deps.pathDependencyPackages;

  nodeModules = stdenv.mkDerivation {
    pname = "corgi-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    strictDeps = true;
    __structuredAttrs = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out/

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-jea/IXa69PaPiC5lpeZaAk5xBtXhEhIpHYw6uJy6VIo=";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "corgi";
  inherit version src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    bun
    writableTmpDirAsHomeHook
    zig_0_17
  ];

  postPatch = ''
    substituteInPlace build.ts \
      --replace-fail \
      'const translated = await translations.verify();' \
      'const translated = { code: 0, text: "" };'

    substituteInPlace build.ts \
      --replace-fail \
      'args.push("--prefix", nativeRoot);' \
      'args.push("--system", "${deps}", ${zigForks}"--prefix", nativeRoot);'
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${nodeModules}/node_modules ./node_modules
    chmod -R u+w ./node_modules
    ${lib.concatMapStringsSep "\n" (
      p: "cp -rL --no-preserve=mode ${deps}/${p} fork-${p}"
    ) deps.pathDependencyPackages}

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun build.ts \
      --release-version ${finalAttrs.version} \
      --release-commit ${commit}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/corgi $out/bin/corgi

    runHook postInstall
  '';

  dontStrip = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Terminal multiplexer for humans and agents";
    homepage = "https://corgi.computer";
    changelog = "https://github.com/tals/corgi/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Dev380 ];
    mainProgram = "corgi";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
