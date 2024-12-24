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

  # buildInputs
  freetype,
  glib,
  gtk3,
  libxkbcommon,
  openssl,
  vulkan-loader,
  wayland,
  apple-sdk_11,

  versionCheckHook,

  # passthru
  nix-update-script,
  python3Packages,
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
  buildFeatures = [ "native_viewer" ];

  nativeBuildInputs = [
    (lib.getBin binaryen) # wasm-opt

    # @SomeoneSerge: Upstream suggests `mold`, but I didn't get it to work
    lld

    pkg-config
    protobuf
    rustfmt
  ];

  buildInputs =
    [
      freetype
      glib
      gtk3
      (lib.getDev openssl)
      libxkbcommon
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ (lib.getLib wayland) ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Undefined symbols for architecture x86_64: "_NSAccessibilityTabButtonSubrole"
      # ld: symbol(s) not found for architecture x86_64
      apple-sdk_11
    ];

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
