{
  lib,
  pkgs,
  stdenvNoCC,
  fetchFromGitHub,
  npm-lockfile-fix,
  bun,
  writableTmpDirAsHomeHook,
}:
let
  fridaNodePrebuilds = pkgs."frida-node-prebuilds";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "igf";
  # The latest npm tag is currently incompatible with modern Frida; use upstream's
  # revived snapshot until a new release is published.
  version = "0.20.0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "ChiChou";
    repo = "Grapefruit";
    rev = "acc0506eb6f1b477564816eeef2781462fedb437";
    hash = "sha256-5prjcojnz4NGh1CVtsihQfOm5emONnJufLWfFLtOqwg=";
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -R ./node_modules $out
      runHook postInstall
    '';

    outputHash = "sha256-fY9N8skqABZCKvSJmfBvXGRIMcgJnR1rgcEHqbrwuW4=";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure
    mkdir -p node_modules
    cp -R ${finalAttrs.node_modules}/. node_modules/
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    bun scripts/build-npm.ts
    bun node_modules/tsdown/dist/run.mjs --env.NODE_ENV=production
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    packageOut="$out/lib/node_modules/igf"
    mkdir -p "$packageOut"

    cp -r dist "$packageOut/"
    cp -r bin "$packageOut/"
    cp -r drizzle "$packageOut/"
    cp package.json "$packageOut/"
    cp -r node_modules "$packageOut/"
    chmod -R u+w "$packageOut/node_modules/frida" "$packageOut/node_modules/frida16"
    substituteInPlace "$packageOut/dist/index.mjs" \
      --replace-fail '"..", "..", "drizzle"' '"..", "drizzle"'

    # Runtime can select either major version through FRIDA_VERSION/--frida.
    cp -r ${fridaNodePrebuilds}/frida/build "$packageOut/node_modules/frida/"
    cp -r ${fridaNodePrebuilds}/frida16/build "$packageOut/node_modules/frida16/"

    mkdir -p "$out/bin"
    printf '%s\n' \
      "#!${stdenvNoCC.shell}" \
      "exec ${lib.getExe bun} \"$packageOut/dist/index.mjs\" \"\$@\"" \
      > "$out/bin/igf"
    chmod +x "$out/bin/igf"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/igf --help >/dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Runtime application instrumentation toolkit powered by Frida";
    homepage = "https://github.com/ChiChou/Grapefruit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caverav ];
    mainProgram = "igf";
    platforms = (fridaNodePrebuilds.meta.platforms or [ ]);
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
