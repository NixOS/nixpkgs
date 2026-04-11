{
  binaryen,
  cargo-leptos,
  fetchFromGitHub,
  lib,
  rustc,
  makeWrapper,
  nix-update-script,
  rustPlatform,
  tailwindcss_3,
  wasm-bindgen-cli_0_2_106,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "idmail";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "idmail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b18Ic+wffCPfp1cDTxDe7IBigbS4X6t7KaAy7P4Uh28=";
  };

  cargoHash = "sha256-FU9CfOJ9tNY+97OZDw2qYZHTPoFp9Ch2VigXaxBnFCw=";

  env = {
    RUSTC_BOOTSTRAP = 1;
    RUSTFLAGS = "--cfg=web_sys_unstable_apis";
  };

  nativeBuildInputs = [
    wasm-bindgen-cli_0_2_106
    binaryen
    cargo-leptos
    rustc.llvmPackages.lld
    tailwindcss_3
    makeWrapper
  ];
  buildPhase = ''
    runHook preBuild

    cargo leptos build --release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp target/release/idmail $out/bin
    cp -r target/site $out/share
    wrapProgram $out/bin/idmail --set LEPTOS_SITE_ROOT $out/share/site

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Email alias and account management interface for self-hosted mailservers";
    homepage = "https://github.com/oddlama/idmail";
    changelog = "https://github.com/oddlama/idmail/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "idmail";
  };
})
