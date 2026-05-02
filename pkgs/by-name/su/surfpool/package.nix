{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchzip,
  pkg-config,
  versionCheckHook,
  openssl,
}:

let
  studioUiVersion = "v0.1.0";
  studioUi = fetchzip {
    url = "https://github.com/solana-foundation/surfpool-web-ui/releases/download/${studioUiVersion}/studio-dist.zip";
    hash = "sha256-uZZpaAIg7f+ji5yonwNbAxbxi+4x7g5V4xKWUXNn1UI=";
    stripRoot = false;
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "surfpool-cli";
  version = "1.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "solana-foundation";
    repo = "surfpool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PGCzlnu7YxueQ16uae2818I9vXWdMRFRGaFzg2DIIgo=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-ephKNAJ9PtTz/EN9dGFn6LnIySU0g/GNz8Jg9JDKTSI=";

  postPatch = ''
    # instead of downloading the surfpool-web-ui at build time, we fetch it beforehand and use it
    # https://github.com/solana-foundation/surfpool/pull/628
    substituteInPlace crates/studio/build.rs \
      --replace-fail \
        'let url = match env::var("STUDIO_UI_VERSION") {' \
        'if let Ok(dist_path) = env::var("STUDIO_UI_DIST") {
            let src = std::path::Path::new(&dist_path);
            fn copy_dir(s: &std::path::Path, d: &std::path::Path) {
                std::fs::create_dir_all(d).unwrap();
                for e in std::fs::read_dir(s).unwrap() {
                    let e = e.unwrap();
                    if e.file_type().unwrap().is_dir() { copy_dir(&e.path(), &d.join(e.file_name())); }
                    else { std::fs::copy(e.path(), d.join(e.file_name())).unwrap(); }
                }
            }
            copy_dir(src, &asset_dir);
            return;
        }
        let url = match env::var("STUDIO_UI_VERSION") {'
  '';

  env = {
    RUSTFLAGS = "-Aunused";
    OPENSSL_NO_VENDOR = 1;
    STUDIO_UI_DIST = "${studioUi}";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Surfpool is where developers start their Solana journey";
    homepage = "https://www.surfpool.run/";
    longDescription = ''
      Surfpool is a drop-in replacement for solana-test-validator that lets
      developers spin up local Solana networks mirroring mainnet state without
      downloading the entire chain. It includes a built-in web UI (Surfpool Studio)
      served directly from the binary, Infrastructure as Code for declarative
      program deployment, transaction inspection, time travel, cheatcodes, and
      an MCP server for agentic workflows
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _0xgsvs ];
    mainProgram = "surfpool";
  };
})
