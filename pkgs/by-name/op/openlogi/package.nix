{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  cargo-bundle,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openlogi";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "OpenLogi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WkNRojSfjaejcpI/rILfIgX6LHr7bsxVa+rs2izno14=";
  };

  # One FOD vendors every dependency, including the zed / wgpu / font-kit git
  # forks gpui pulls in (same approach as zed-editor).
  cargoHash = "sha256-xtO10OkV334y7FSuY+1Bof5aZsm+lwW9rc7I22U8Mjs=";

  __structuredAttrs = true;

  postPatch = ''
    # .cargo/config.toml forces linker=/usr/bin/cc + an Xcode DEVELOPER_DIR for
    # local dev; neither exists in the sandbox (zed-editor drops its config too).
    rm -f .cargo/config.toml

    # gpui-component's IconName proc-macro reads ../assets/assets/icons relative
    # to its crate, assuming the upstream repo layout; cargo vendors each git
    # crate separately, so re-link the gpui-component-assets crate.
    ( cd "$cargoDepsCopy/source-git-1" && ln -sfn gpui-component-assets-* assets )
  '';

  nativeBuildInputs = [
    cargo-bundle
    # `media` (a gpui dep) runs bindgen in its build script; bindgenHook gives it
    # libclang + the SDK include paths (same as zed-editor).
    rustPlatform.bindgenHook
  ];

  # Only the GUI crate; the openlogi CLI doesn't carry the gpui_platform feature.
  cargoBuildFlags = [ "--package=openlogi-gui" ];

  # Compile Metal shaders at runtime — the proprietary metal compiler isn't in
  # the sandbox (the trick zed-editor uses to ship gpui on darwin).
  buildFeatures = [ "gpui_platform/runtime_shaders" ];

  # GUI binary with no sandbox-runnable tests; a checkPhase would also need
  # `gpui_platform/runtime_shaders` in checkFeatures to dodge the Metal compiler,
  # for no benefit.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
    mv "$release_target/openlogi-gui" target/release/openlogi-gui

    pushd crates/openlogi-gui
    export CARGO_BUNDLE_SKIP_BUILD=true
    app_path=$(cargo bundle --release | xargs)
    popd

    mkdir -p "$out/Applications"
    mv "$app_path" "$out/Applications/"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first alternative to Logitech Options+ for HID++ devices";
    homepage = "https://openlogi.org/";
    changelog = "https://github.com/AprilNEA/OpenLogi/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ aprilnea ];
    platforms = lib.platforms.darwin;
  };
})
