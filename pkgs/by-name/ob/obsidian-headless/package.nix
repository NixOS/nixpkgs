{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  srcOnly,
  node-gyp,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  python3,
  cctools,
  versionCheckHook,
}:

let
  nodeSources = srcOnly nodejs;
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "obsidian-headless";
  version = "0.0.11";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "obsidianmd";
    repo = "obsidian-headless";
    tag = finalAttrs.version;
    hash = "sha256-zjMdOCuOMMvBZhrXf7nkz8sYAQ0vU+TzyHhlwIbEfHU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-mhf9C221F16MwcReWy2UnSqa6jpOqGlH4DPLpu88Jsw=";
  };

  nativeBuildInputs = [
    nodejs
    node-gyp
    pnpmConfigHook
    pnpm
    makeWrapper
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  buildPhase = ''
    runHook preBuild

    pushd node_modules/better-sqlite3
    npm run build-release --offline "--nodedir=${nodeSources}"
    mv build/Release/better_sqlite3.node .
    rm -rf build
    mkdir -p build/Release
    mv better_sqlite3.node build/Release/
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/obsidian-headless
    cp -r cli.js btime node_modules package.json $out/lib/obsidian-headless/

    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/ob \
      --add-flags $out/lib/obsidian-headless/cli.js

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Headless client for Obsidian Sync and Obsidian Publish";
    homepage = "https://github.com/obsidianmd/obsidian-headless";
    changelog = "https://github.com/obsidianmd/obsidian-headless/releases/tag/${finalAttrs.version}";
    license = lib.licenses.obsidian;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      nadir-ishiguro
    ];
    mainProgram = "ob";
  };
})
