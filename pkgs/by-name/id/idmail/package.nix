{
  binaryen,
  cargo-leptos,
  fetchFromGitHub,
  lib,
  rustc,
  makeWrapper,
  nix-update-script,
  nodePackages,
  rustPlatform,
  tailwindcss_3,
  wasm-bindgen-cli_0_2_100,
}:
let
  tailwindcss = tailwindcss_3.overrideAttrs (_prev: {
    plugins = [
      nodePackages."@tailwindcss/aspect-ratio"
      nodePackages."@tailwindcss/forms"
      nodePackages."@tailwindcss/line-clamp"
      nodePackages."@tailwindcss/typography"
    ];
  });
in
rustPlatform.buildRustPackage rec {
  pname = "idmail";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "oddlama";
    repo = "idmail";
    tag = "v${version}";
    hash = "sha256-9rl2UG8DeWd8hVh3N+dqyV5gO0LErok+kZ1vQZnVAe8=";
  };

  cargoHash = "sha256-UcS2gAoa2fzPu6hh8I5sXSHHbAmzsecT44Ju2CVsK0Q=";

  RUSTC_BOOTSTRAP = 1;
  RUSTFLAGS = "--cfg=web_sys_unstable_apis";

  nativeBuildInputs = [
    wasm-bindgen-cli_0_2_100
    binaryen
    cargo-leptos
    rustc.llvmPackages.lld
    tailwindcss
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
    changelog = "https://github.com/oddlama/idmail/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "idmail";
  };
}
