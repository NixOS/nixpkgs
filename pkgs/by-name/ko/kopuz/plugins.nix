{
  lib,
  lld,
  pkgsCross,
  rustPlatform,
  runCommand,
  wasm-component-ld,
  src,
  version,
  cargoDeps,
}:

let
  target = "wasm32-wasip2";
  crossPkgs = pkgsCross.wasm32-wasip1;
  crossRust = crossPkgs.buildPackages;

  # Rust looks for wasi-libc under the Preview 2 target name. The component
  # linker adapts the Preview 1 ABI used by this libc.
  wasiRoot = runCommand "kopuz-wasi-sysroot" { } ''
    mkdir -p "$out/lib"
    ln -s ${crossPkgs.wasilibc}/lib/wasm32-wasip1 "$out/lib/${target}"
  '';

  rustcUnwrapped = crossRust.rustc-unwrapped.overrideAttrs (oldAttrs: {
    configureFlags =
      map (lib.replaceStrings
        [ "--target=wasm32-wasip1" ''target."wasm32-wasip1"'' ]
        [ "--target=${target}" ''target."${target}"'' ]
      ) (lib.filter (flag: !(lib.hasInfix ".wasi-root=" flag)) oldAttrs.configureFlags)
      ++ [ ''--set=target."${target}".wasi-root=${wasiRoot}'' ];
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ wasm-component-ld ];
  });
  rustc = crossRust.wrapRustcWith {
    rustc-unwrapped = rustcUnwrapped;
    sysroot = rustcUnwrapped;
  };
in
rustPlatform.buildRustPackage {
  pname = "kopuz-plugins";
  inherit version src cargoDeps;

  nativeBuildInputs = [ lld ];

  # cargo-auditable embeds metadata in native executables. These outputs are Wasm components.
  auditable = false;
  env = {
    RUSTC = lib.getExe rustc;
    CARGO_TARGET_WASM32_WASIP2_LINKER = lib.getExe wasm-component-ld;
  };

  buildPhase = ''
    runHook preBuild
    cargo build --offline --locked --target ${target} --profile plugin \
      -p kopuz-plugin-clippsly -p kopuz-plugin-jellyfin \
      -p kopuz-plugin-soundcloud -p kopuz-plugin-subsonic
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 -t "$out" target/${target}/plugin/*.wasm
    runHook postInstall
  '';

  doCheck = false;
}
