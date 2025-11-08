{
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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-desktop";
  version = "0.8.0";

  src = fetchFromRadicle {
    seed = "seed.radicle.xyz";
    repo = "z4D5UCArafTzTQpDZNQRuqswh3ury";
    rev = "aeb405aaf53b56a426ab8d68c7f89b8953683224";
    hash = "sha256-Z/6GdXf3ag/89H8UMD2GNU4CXA8TWyX8dl8uh0CTem8=";
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
    hash = "sha256-lcSNGmIv6u7DT47lOC69BRbVSK5IPiwjtdAS8aVxwqM=";
  };

  cargoHash = "sha256-z5fnwc7EjSvkyu4zTUyAvVfs6quwH2p9VFDK/TdzZJE=";

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
    webkitgtk_4_1
  ];

  preBuild = ''
    export GIT_HEAD=$(<$src/.git_head)
  '';

  nativeCheckInputs = [
    git
    openssh
    radicle-node
    rustfmt
    clippy
  ];

  checkPhase = ''
    runHook preCheck

    export RAD_HOME="$PWD/_rad-home"
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

  passthru.env = finalAttrs.env;

  meta = {
    description = "Radicle desktop app";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z4D5UCArafTzTQpDZNQRuqswh3ury";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z4D5UCArafTzTQpDZNQRuqswh3ury/tree/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      defelo
      faukah
    ];
    mainProgram = "radicle-desktop";
  };
})
