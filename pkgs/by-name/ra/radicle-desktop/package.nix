{
  fetchFromGitHub,
  cargo-tauri,
  fetchgit,
  git,
  glib,
  gtk3,
  importNpmLock,
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
}:

let
  twemoji-assets = fetchFromGitHub {
    owner = "twitter";
    repo = "twemoji";
    tag = "v14.0.2";
    hash = "sha256-YoOnZ5uVukzi/6bLi22Y8U5TpplPzB7ji42l+/ys5xI=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-desktop";
  version = "0.8.0";

  src = fetchgit {
    url = "https://seed.radicle.xyz/z4D5UCArafTzTQpDZNQRuqswh3ury.git";
    rev = "aeb405aaf53b56a426ab8d68c7f89b8953683224";
    hash = "sha256-DdjmE4Jgf1oGqJpVF7piBtCjt07pb7er1ZaFaVYr+wY=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git_head
      git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
      rm -rf $out/.git
    '';
  };

  npmDeps = importNpmLock {
    version = finalAttrs.version;
    pname = finalAttrs.pname + "-npm-deps";
    npmRoot = finalAttrs.src;
  };

  cargoHash = "sha256-z5fnwc7EjSvkyu4zTUyAvVfs6quwH2p9VFDK/TdzZJE=";

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    importNpmLock.npmConfigHook
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

  propagatedBuildInputs = [
    radicle-node
  ];

  postPatch = ''
    patchShebangs scripts/copy-katex-assets scripts/check-js scripts/check-rs
    mkdir -p public/twemoji
    cp -t public/twemoji -r -- ${twemoji-assets}/assets/svg/*
    : >scripts/install-twemoji-assets
  '';

  doCheck = false;

  nativeCheckInputs = [
    git
    openssh
  ];

  env = {
    HW_RELEASE = "nix-" + (radicle-node.shortRev or "unknown-ref");
    PLAYWRIGHT_BROWSERS_PATH = playwright-driver.browsers;
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;
  };

  preCheck = ''
    export RAD_HOME="$PWD/_rad-home"
    export RAD_PASSPHRASE=""
    rad auth --alias test
    bins="tests/tmp/bin/heartwood/$HW_RELEASE"
    mkdir -p "$bins"
    cp -t "$bins" -- ${radicle-node}/bin/*
    printf "$HW_RELEASE" >tests/support/heartwood-release
  '';

  checkPhase = ''
    runHook preCheck

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
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z4D5UCArafTzTQpDZNQRuqswh3ury/tree/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "radicle-desktop";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
