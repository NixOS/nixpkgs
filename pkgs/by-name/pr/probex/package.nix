{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  cargo,
  bpf-linker,
  dioxus-cli,
  wasm-bindgen-cli_0_2_108,
  binaryen,
  tailwindcss_4,
  lld,
  fetchurl,
}:

let
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "XiangpengHao";
    repo = "probex";
    rev = "v${version}";
    hash = "sha256-yMWnL55jvPMeE6XhepBksujVz33nYJvzHTSChtNdvDw=";
  };

  cargoVendorHash = "sha256-iRBps3ghGt4IRhPRp2aywwvaFNxa2fQcEAKK72xxbPs=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = cargoVendorHash;
  };

  # daisyUI vendor files
  daisyui-bundle = fetchurl {
    url = "https://github.com/saadeghi/daisyui/releases/download/v5.5.14/daisyui.mjs";
    sha256 = "sha256-ZhCaZQYZiADXoO3UwaAqv3cxiYu87LEiZuonefopRUw=";
  };
  daisyui-theme-bundle = fetchurl {
    url = "https://github.com/saadeghi/daisyui/releases/download/v5.5.14/daisyui-theme.mjs";
    sha256 = "sha256-PPO2fLQ7eB+ROYnpmK5q2LHIoWUE+EcxYmvjC+gzgSw=";
  };

  # Phase 1: Build eBPF binary
  # nixpkgs rustc ships with precompiled BPF targets (since NixOS/nixpkgs#382166),
  # so no nightly or -Z build-std=core needed.
  probex-ebpf-binary = stdenv.mkDerivation {
    pname = "probex-ebpf-binary";
    inherit version src;

    nativeBuildInputs = [
      rustc
      cargo
      bpf-linker
    ];

    dontConfigure = true;
    doCheck = false;

    buildPhase = ''
      runHook preBuild

      mkdir -p .cargo
      cat > .cargo/config.toml <<EOF
      [source.crates-io]
      replace-with = "vendored-sources"

      [source.vendored-sources]
      directory = "${cargoDeps}"
      EOF

      RUSTC_BOOTSTRAP=1 \
      CARGO_ENCODED_RUSTFLAGS=$'--cfg=bpf_target_arch="x86_64"\x1f-Cdebuginfo=2\x1f-Clink-arg=--btf' \
        cargo build \
          --package probex-ebpf \
          --bins \
          --release \
          --target bpfel-unknown-none \
          --offline

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp target/bpfel-unknown-none/release/probex $out/probex
      runHook postInstall
    '';
  };

  # Phase 2: Build viewer assets
  probex-viewer-assets = stdenv.mkDerivation {
    pname = "probex-viewer-assets";
    inherit version src;

    nativeBuildInputs = [
      rustc
      cargo
      bpf-linker
      dioxus-cli
      wasm-bindgen-cli_0_2_108
      binaryen
      tailwindcss_4
      lld
    ];

    dontConfigure = true;
    doCheck = false;

    buildPhase = ''
      runHook preBuild

      mkdir -p .cargo
      cat > .cargo/config.toml <<EOF
      [source.crates-io]
      replace-with = "vendored-sources"

      [source.vendored-sources]
      directory = "${cargoDeps}"
      EOF

      mkdir -p vendor
      cp -f ${daisyui-bundle} vendor/daisyui.mjs
      cp -f ${daisyui-theme-bundle} vendor/daisyui-theme.mjs

      dx bundle --release --platform web -p probex-viewer

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -a target/dx/probex-viewer/release/web/public/. $out/
      runHook postInstall
    '';
  };
in
# Phase 3: Build probex binary with pre-built assets
rustPlatform.buildRustPackage {
  pname = "probex";
  inherit version src;

  cargoHash = cargoVendorHash;

  nativeBuildInputs = [ bpf-linker ];

  env = {
    PROBEX_SKIP_EBPF_BUILD = "1";
    PROBEX_SKIP_FRONTEND_BUNDLE = "1";
  };

  postPatch = ''
    mkdir -p probex/assets/ebpf/x86_64
    cp ${probex-ebpf-binary}/probex probex/assets/ebpf/x86_64/probex

    rm -rf probex/assets/viewer
    mkdir -p probex/assets/viewer
    cp -a ${probex-viewer-assets}/. probex/assets/viewer/
  '';

  cargoBuildFlags = [
    "-p"
    "probex"
  ];

  doCheck = false;

  meta = {
    description = "The missing Linux profiler — low-friction, easy to use, works out of the box";
    homepage = "https://github.com/XiangpengHao/probex";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ xiangpenghao ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "probex";
  };
}
