{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  srcOnly,
  node-gyp,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  python3,
  cctools,
}:

let
  nodeSources = srcOnly nodejs;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "obsidian-headless";
  version = "0.0.9";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "obsidianmd";
    repo = "obsidian-headless";
    rev = "5f51535b744625ee2cf47d61f704d4d9276590b7";
    hash = "sha256-RnLiCbAgetMO8pXYNjNW7fPeR8O7/Zz2i/x5OXOL+8U=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      postPatch
      ;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-Y/atHIJQzrt6ctpI2ks7Mj0bnTCQx4d5mDtY/YIEcow=";
  };

  nativeBuildInputs = [
    nodejs
    node-gyp
    pnpmConfigHook
    pnpm_9
    makeWrapper
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
  ];

  postPatch = ''
    cp ${./pnpm-lock.yaml} ./pnpm-lock.yaml
  '';

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

  meta = {
    description = "Headless client for Obsidian Sync and Obsidian Publish. Sync and publish your vaults from the command line without the desktop app";
    homepage = "https://github.com/obsidianmd/obsidian-headless";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      halfwhey
    ];
    mainProgram = "ob";
  };
})
