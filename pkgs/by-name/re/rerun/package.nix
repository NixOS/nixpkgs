{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  # nativeBuildInputs
  binaryen,
  lld,
  pkg-config,
  protobuf,
  rustfmt,
  nasm,
  # buildInputs
  freetype,
  glib,
  gtk3,
  libxkbcommon,
  openssl,
  vulkan-loader,
  wayland,
  versionCheckHook,
  # passthru
  nix-update-script,
  python3Packages,
  # Expose features to the user for the wasm web viewer build
  # So he can easily override them
  # We omit the "analytics" feature because it is opt-out and not opt-in.
  # More information can be found in there README:
  # https://raw.githubusercontent.com/rerun-io/rerun/5a9794990c4903c088ad77174e65eb2573162d97/crates/utils/re_analytics/README.md
  buildWebViewerFeatures ? [
    "grpc"
    "map_view"
  ],
}:

rustPlatform.buildRustPackage rec {
  pname = "rerun";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "rerun-io";
    repo = "rerun";
    tag = version;
    hash = "sha256-U+Q8u1XKBD9c49eXAgc5vASKytgyAEYyYv8XNfftlZU=";
  };

  # The path in `build.rs` is wrong for some reason, so we patch it to make the passthru tests work
  postPatch = ''
    substituteInPlace rerun_py/build.rs \
      --replace-fail '"rerun_sdk/rerun_cli/rerun"' '"rerun_sdk/rerun"'
  '';

  cargoHash = "sha256-d68dNAAGY+a0DpL82S/qntu2XOsoVqHpfU2L9NcoJQc=";

  cargoBuildFlags = [ "--package rerun-cli" ];
  cargoTestFlags = [ "--package rerun-cli" ];
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "native_viewer"
    "web_viewer"
    "nasm"
  ];

  # Forward as a bash environment variable to the preBuild hook
  inherit buildWebViewerFeatures;

  # When web_viewer is compiled, the wasm webviewer first needs to be built
  # If this doesn't exist, the build will fail. More information: https://github.com/rerun-io/rerun/issues/6028
  # The command is taken from https://github.com/rerun-io/rerun/blob/dd025f1384f9944d785d0fb75ca4ca1cd1792f17/pixi.toml#L198C72-L198C187
  # Note that cargoBuildFeatures reference what buildFeatures is set to in stdenv.mkDerivation,
  # so that user can easily create an overlay to set cargoBuildFeatures to what he needs
  preBuild = ''
    if [[ " $cargoBuildFeatures " == *" web_viewer "* ]]; then
      # transform the environment variable that is a space separated list into a comma separated list
      buildWebViewerFeatures=$(echo $buildWebViewerFeatures | tr ' ' ',')
      # Create the features option only if there are features to pass
      buildWebViewerFeaturesCargoOption=""
      if [[ ! -z "$buildWebViewerFeatures" ]]; then
        buildWebViewerFeaturesCargoOption="--features $buildWebViewerFeatures"
        echo "Features passed to the web viewer build: $buildWebViewerFeatures"
      else
        echo "No features will be passed to the web viewer build"
      fi
      echo "Building the wasm web viewer for rerun's web_viewer feature"
      cargo run -p re_dev_tools -- build-web-viewer --no-default-features $buildWebViewerFeaturesCargoOption --release -g
    else
      echo "web_viewer feature not enabled, skipping web viewer build."
    fi
  '';

  nativeBuildInputs = [
    (lib.getBin binaryen) # wasm-opt

    # @SomeoneSerge: Upstream suggests `mold`, but I didn't get it to work
    lld

    pkg-config
    protobuf
    rustfmt
    nasm
  ];

  buildInputs = [
    freetype
    glib
    gtk3
    (lib.getDev openssl)
    libxkbcommon
    vulkan-loader
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ (lib.getLib wayland) ];

  addDlopenRunpaths = map (p: "${lib.getLib p}/lib") (
    lib.optionals stdenv.hostPlatform.isLinux [
      libxkbcommon
      vulkan-loader
      wayland
    ]
  );

  addDlopenRunpathsPhase = ''
    elfHasDynamicSection() {
        patchelf --print-rpath "$1" >& /dev/null
    }

    while IFS= read -r -d $'\0' path ; do
      elfHasDynamicSection "$path" || continue
      for dep in $addDlopenRunpaths ; do
        patchelf "$path" --add-rpath "$dep"
      done
    done < <(
      for o in $(getAllOutputNames) ; do
        find "''${!o}" -type f -and "(" -executable -or -iname '*.so' ")" -print0
      done
    )
  '';

  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "addDlopenRunpathsPhase" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (python3Packages) rerun-sdk;
    };
  };

  meta = {
    description = "Visualize streams of multimodal data. Fast, easy to use, and simple to integrate.  Built in Rust using egui";
    homepage = "https://github.com/rerun-io/rerun";
    changelog = "https://github.com/rerun-io/rerun/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      SomeoneSerge
      robwalt
    ];
    mainProgram = "rerun";
  };
}
