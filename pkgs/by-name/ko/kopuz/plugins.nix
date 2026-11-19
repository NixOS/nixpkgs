{
  pkgsCross,
  lld,
  wasm-component-ld,
  kopuz,
}:

pkgsCross.wasm32-wasip1.rustPlatform.buildRustPackage {
  pname = "kopuz-plugins";
  inherit (kopuz) version src cargoDeps;

  __structuredAttrs = true;

  nativeBuildInputs = [
    lld
    wasm-component-ld
  ];

  env.RUSTFLAGS = "-C linker=wasm-component-ld";

  buildType = "plugin";
  cargoBuildFlags = [
    "-p"
    "kopuz-plugin-clippsly"
    "-p"
    "kopuz-plugin-jellyfin"
    "-p"
    "kopuz-plugin-soundcloud"
    "-p"
    "kopuz-plugin-subsonic"
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t "$out" target/wasm32-wasip1/plugin/*.wasm
    runHook postInstall
  '';

  meta = {
    inherit (kopuz.meta) homepage license maintainers;
    description = "Official source plugins embedded in kopuz";
  };
}
