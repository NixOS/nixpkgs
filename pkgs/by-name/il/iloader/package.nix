{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  cargo-tauri,
  jq,
  moreutils,
  nodejs,
  pkg-config,
  bun,

  openssl,
  webkitgtk_4_1,

  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "iloader";
  version = "2.2.4";

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  src = fetchFromGitHub {
    owner = "nab138";
    repo = "iloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cKUyxNsnqG1GSD+zMNjIoOkl4+IHRfWLQQo8IDjIS/o=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-ryXbUBNtMjZcQGivnjqRBxbGsW6UAJbU38rTqzwvH+Y=";
  };

  node_modules = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "iloader-node_modules";
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];
    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];
    dontConfigure = true;
    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install --no-progress --frozen-lockfile --no-cache

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';
    outputHash =
      {
        x86_64-linux = "sha256-qQX+FjFdM5MuO//211RNghP1VTh1EHPYVhaU2D+nqbc=";
        aarch64-linux = lib.fakeHash;
        x86_64-darwin = lib.fakeHash;
        aarch64-darwin = lib.fakeHash;
      }
      .${stdenv.hostPlatform.system};
    # .${stdenv.hostPlatform.system}
    # or (throw "${finalAttrs.pname}: Platform ${stdenv.hostPlatform.system} is not packaged yet. Supported platforms: x86_64-linux, aarch64-linux.");
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    rustPlatform.cargoSetupHook

    jq
    moreutils
    nodejs
    bun

    pkg-config
  ];

  buildInputs = [
    openssl
    webkitgtk_4_1
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postPatch = ''
    jq '
      .bundle.createUpdaterArtifacts = false |
      .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
    ' \
    src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/node_modules .

    # Bun takes executables from this folder
    chmod -R u+rw node_modules
    chmod -R u+x node_modules/.bin
    patchShebangs node_modules

    export HOME=$TMPDIR
    export PATH="$PWD/node_modules/.bin:$PATH"

    runHook postConfigure
  '';

  meta = with lib; {
    description = "User friendly sideloader ";
    homepage = "https://iloader.app";
    changelog = "https://github.com/nab138/iloader/releases/tag/v${finalAttrs.version}";
    platforms = platforms.all;
    maintainers = with maintainers; [ not-a-cowfr ];
    license = licenses.mit;
    mainProgram = finalAttrs.pname;
  };
})
