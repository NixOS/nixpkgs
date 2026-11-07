{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  cargo-tauri,
  bun,
  nodejs,
  writableTmpDirAsHomeHook,
  pkg-config,
  wrapGAppsHook4,
  jq,
  glib-networking,
  libayatana-appindicator,
  openssl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "athas";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "athasdev";
    repo = "athas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YZB5yOu1VrCILUYlxWOYfvOGzmlZu6R6/V8zwfKFF0g=";
  };

  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-8aBp2JtfpS7P1x7av1cq88BuYunZ7BjMHnBZLUJ9sNA=";

  doCheck = false;

  __structuredAttrs = true;

  node_modules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;

    nativeBuildInputs = [
      bun
      nodejs
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --backend=copyfile \
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
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      # Remove Windows executables fetched by --os="*"
      find $out -type f -name '*.exe' -delete

      runHook postInstall
    '';

    dontFixup = true;
    outputHash = "sha256-jplT9Y1ra4fS97HFbruai03MD77aP6Uimgm2rDLht+M=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  postPatch = ''
    cp -R ${finalAttrs.node_modules}/. .
    find . -type d -name node_modules -exec chmod -R u+rw {} \;
    find . -path "*/node_modules/.bin" -type d -exec chmod -R u+x {} \;
    patchShebangs .

    # Disable updater artifact generation in cargo-tauri build
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json > src-tauri/tauri.conf.json.tmp
    mv src-tauri/tauri.conf.json.tmp src-tauri/tauri.conf.json

    # Fix libayatana-appindicator path
    libappindicatorSys=$(find $cargoDepsCopy -path '*/libappindicator-sys-*/src/lib.rs' -print -quit)
    if [ -n "$libappindicatorSys" ]; then
      substituteInPlace "$libappindicatorSys" \
        --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    fi
  '';

  postInstall = ''
    # Disable in-app updater; updates are handled by Nix
    touch "$out/bin/managed-by-package-manager"
  '';

  # Tauri runs beforeBuildCommand (`vp build`) via plain sh, so
  # node_modules/.bin must be on PATH for the vite-plus CLI to resolve.
  preBuild = ''
    export PATH="$PWD/node_modules/.bin:$PATH"
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    bun
    nodejs
    writableTmpDirAsHomeHook
    pkg-config
    wrapGAppsHook4
    jq
  ];

  buildInputs = [
    glib-networking
    libayatana-appindicator
    openssl
    webkitgtk_4_1
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru = {
    inherit (finalAttrs) node_modules;

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage=node_modules"
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "Lightweight code editor with Git, a terminal and AI agents";
    homepage = "https://github.com/athasdev/athas";
    changelog = "https://github.com/athasdev/athas/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ _0x4bs3nt ];
    mainProgram = "athas";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
