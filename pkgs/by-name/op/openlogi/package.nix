{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-bundle,
  libicns,
  resvg,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openlogi";
  version = "0.3.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "OpenLogi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-04o/Ry65CdNtycgJfqhXwTD5InUwfkr88xQ+I/5Pe4o=";
  };

  cargoHash = "sha256-nKQRcRsEq5JJpn0DZIssS/wAwVsj4kq9J2WmQXJ3smY=";

  postPatch = ''
    # gpui-component generates its IconName enum from a sibling assets directory,
    # but cargo vendoring stores gpui-component-assets as a separate package.
    for component in "$cargoDepsCopy"/source-git-*/gpui-component-[0-9]*; do
      component_parent=$(dirname "$component")
      ln -s "$component_parent"/gpui-component-assets-* "$component_parent/assets"
    done

    # Dev-only cargo runner wraps test binaries in a throwaway .app bundle;
    # the Nix darwin sandbox refuses to exec it, so cargo test aborts with
    # EPERM before the binary runs. Strip it — tests don't need the bundle.
    substituteInPlace .cargo/config.toml \
      --replace-fail 'runner = "scripts/cargo-run-macos.sh"' ""
  '';

  nativeBuildInputs = [
    cargo-bundle
    libicns
    resvg
    rustPlatform.bindgenHook
  ];

  cargoBuildFlags = [
    "--package=openlogi"
    "--package=openlogi-gui"
  ];

  cargoTestFlags = [ "--workspace" ];

  buildFeatures = lib.optionals stdenv.hostPlatform.isDarwin [
    "gpui_platform/runtime_shaders"
  ];

  # Upstream intentionally fetches optional device images on first launch
  # unless OPENLOGI_BUNDLE_ASSETS is set while bundling.
  preBuild = ''
    iconset=$(mktemp -d)
    for size in 16 32 128 256 512; do
      resvg \
        --width "$size" \
        --height "$size" \
        design/icon/openlogi.svg \
        "$iconset/icon_''${size}x''${size}.png"
    done

    mkdir -p crates/openlogi-gui/icon
    png2icns crates/openlogi-gui/icon/AppIcon.icns "$iconset"/*.png

    rm -rf crates/openlogi-gui/assets
    mkdir -p crates/openlogi-gui/assets
  '';

  installPhase = ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
    mv "$release_target/openlogi-gui" target/release/openlogi-gui

    pushd crates/openlogi-gui
    export CARGO_BUNDLE_SKIP_BUILD=true
    app_path=$(cargo bundle --release | xargs)
    popd

    mkdir -p "$out/Applications" "$out/bin"
    mv "$app_path" "$out/Applications/"
    install -Dm755 "$release_target/openlogi" "$out/bin/openlogi"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first companion for Logitech HID++ peripherals";
    homepage = "https://github.com/AprilNEA/OpenLogi";
    changelog = "https://github.com/AprilNEA/OpenLogi/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "openlogi";
    maintainers = with lib.maintainers; [ imcvampire ];
    platforms = lib.platforms.darwin;
  };
})
