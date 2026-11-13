{
  stdenv,
  fetchFromGitHub,
  cargo-tauri,
  fetchFromRadicle,
  git,
  glib,
  gtk3,
  fetchNpmDeps,
  npmHooks,
  lib,
  libgit2,
  libsoup_3,
  nodejs,
  openssh,
  openssl,
  pkg-config,
  playwright-driver,
  radicle-node,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook4,
  rustfmt,
  clippy,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-desktop";
  version = "0.18.0";

  __structuredAttrs = true;

  src = fetchFromRadicle {
    seed = "seed.radicle.dev";
    repo = "z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    tag = "releases/desktop/${finalAttrs.version}";
    nonConeMode = true;
    sparseCheckout = [
      "/.prettierrc"
      "/desktop"
      "/package-lock.json"
      "/package.json"
      "/shared"
    ];
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git_head
      rm -rf $out/.git
    '';
    hash = "sha256-quxuiqp1PC4Dq0m91kqHvNclIhMau8hWtA599OmbZyo=";
  };

  postPatch = ''
    patchShebangs desktop/scripts/{copy-katex-assets,check-js,check-rs}

    mkdir -p desktop/public/twemoji
    cp -t desktop/public/twemoji -r -- ${finalAttrs.twemojiAssets}/assets/svg/*
    : >desktop/scripts/install-twemoji-assets

    substituteInPlace desktop/scripts/check-rs \
      --replace-fail "-Dwarnings" ""
  '';

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-Cz6HoYGzMhVRwPUbw6S7Dh7FwNEO3r2xj7L8k332ZnE=";
  };

  cargoHash = "sha256-Yt5MyWdVr5Ye0Pdh996pIyHFo/F68fEbQ7Suh634umw=";

  cargoRoot = "desktop";
  buildAndTestSubdir = "desktop";

  twemojiAssets = fetchFromGitHub {
    owner = "twitter";
    repo = "twemoji";
    tag = "v14.0.2";
    hash = "sha256-YoOnZ5uVukzi/6bLi22Y8U5TpplPzB7ji42l+/ys5xI=";
  };

  env = {
    HW_RELEASE = "nixpkgs";
    PLAYWRIGHT_BROWSERS_PATH = playwright-driver.browsers;
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = true;
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    npmHooks.npmConfigHook
    nodejs
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk3
    libgit2
    libsoup_3
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ webkitgtk_4_1 ];

  preBuild = ''
    export GIT_HEAD=$(<$src/.git_head)
  '';

  nativeCheckInputs = [
    git
    openssh
    radicle-node
    rustfmt
    clippy
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    runHook preCheck

    pushd desktop
    export RAD_PASSPHRASE=""
    rad auth --alias test
    bins="tests/tmp/bin/heartwood/$HW_RELEASE"
    mkdir -p "$bins"
    cp -t "$bins" -- ${radicle-node}/bin/*
    echo -n "$HW_RELEASE" >tests/support/heartwood-release

    npm run build:http
    npm run test:unit
    scripts/check-js
    scripts/check-rs
    popd

    runHook postCheck
  '';

  __darwinAllowLocalNetworking = true;

  passthru = {
    inherit (finalAttrs) env;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Radicle desktop app";
    homepage = "https://radicle.network/nodes/seed.radicle.dev/rad:z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    changelog = "https://radicle.network/nodes/seed.radicle.dev/rad:z4V1sjrXqjvFdnCUbxPFqd5p4DtH5/tree/desktop/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.radicle ];
    maintainers = with lib.maintainers; [ faukah ];
    mainProgram = "radicle-desktop";
  };
})
