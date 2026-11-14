{
  lib,
  stdenv,
  rustPlatform,
  aws-lc,
  pkg-config,
  sqlite,
  mesh-llm,
  skippy-native-runtime,
}:

# nixpkgs-update: no auto update
# mesh-llm's update script updates the release.
rustPlatform.buildRustPackage {
  pname = "mesh-llm-ffi";

  __structuredAttrs = true;
  strictDeps = true;

  inherit (skippy-native-runtime) version;
  src = skippy-native-runtime.meshLlmSrc;
  inherit (mesh-llm) cargoDeps postPatch env;

  cargoBuildFlags = [
    "--package"
    "mesh-llm-ffi"
  ];
  # As upstream's mesh/scripts/package-native-sdk.sh; the feature is still empty in 0.79.0.
  buildNoDefaultFeatures = true;
  buildFeatures = [ "embedded-runtime" ];

  nativeBuildInputs = [
    pkg-config
  ];

  # Found through pkg-config by aws-lc-sys and rusqlite's libsqlite3-sys.
  buildInputs = [
    aws-lc
    sqlite
  ];

  # mesh-llm runs the workspace's tests, this crate's included.
  doCheck = false;

  # Only the shared library the SDKs load; cargo's install would also ship the
  # static library and rlib the crate builds.
  installPhase = ''
    runHook preInstall
    install -Dm755 target/*/release/libmeshllm_ffi${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libmeshllm_ffi${stdenv.hostPlatform.extensions.sharedLibrary}
    runHook postInstall
  '';

  meta = {
    description = "Native FFI bridge for MeshLLM language bindings";
    homepage = "https://github.com/Mesh-LLM/mesh-llm";
    inherit (skippy-native-runtime.meta) changelog;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    inherit (skippy-native-runtime.meta) platforms;
  };
}
