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
  version = "0.12.0";

  src = fetchFromRadicle {
    seed = "seed.radicle.dev";
    repo = "z4D5UCArafTzTQpDZNQRuqswh3ury";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-lbLBtLOBLf+w2Oq56JwXtouDykNrRZyrMxYX9131lf8=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git_head
      rm -rf $out/.git
    '';
  };

  postPatch = ''
    patchShebangs scripts/copy-katex-assets scripts/check-js scripts/check-rs

    mkdir -p public/twemoji
    cp -t public/twemoji -r -- ${finalAttrs.twemojiAssets}/assets/svg/*
    : >scripts/install-twemoji-assets

    substituteInPlace scripts/check-rs \
      --replace-fail "-Dwarnings" ""
  '';

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-7dXQ7wRJ2ZzuSplFdZTlfMetYPYA6/GODkuYjFRWfu0=";
  };

  cargoHash = "sha256-UOk9v6tNshe6pNYU2djz50Ep7BEdUd4bLkGadO5VUb0=";

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

    runHook postCheck
  '';

  passthru = {
    inherit (finalAttrs) env;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Radicle desktop app";
    homepage = "https://radicle.network/nodes/seed.radicle.dev/rad:z4D5UCArafTzTQpDZNQRuqswh3ury";
    changelog = "https://radicle.network/nodes/seed.radicle.dev/rad:z4D5UCArafTzTQpDZNQRuqswh3ury/tree/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.radicle ];
    maintainers = with lib.maintainers; [ faukah ];
    mainProgram = "radicle-desktop";
  };
})
