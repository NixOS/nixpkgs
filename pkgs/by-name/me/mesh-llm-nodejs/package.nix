{
  lib,
  stdenv,
  rustPlatform,
  aws-lc,
  pkg-config,
  sqlite,
  nodejs,
  writableTmpDirAsHomeHook,
  mesh-llm,
  skippy-native-runtime,
}:

# nixpkgs-update: no auto update
# mesh-llm's update script updates the release.
rustPlatform.buildRustPackage {
  pname = "mesh-llm-nodejs";

  __structuredAttrs = true;
  strictDeps = true;

  inherit (skippy-native-runtime) version;
  src = skippy-native-runtime.meshLlmSrc;
  inherit (mesh-llm) cargoDeps postPatch env;

  cargoBuildFlags = [
    "--package"
    "mesh-llm-nodejs"
  ];

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

  installPhase = ''
    runHook preInstall
    sdk=$out/lib/node_modules/@mesh-llm/sdk
    mkdir -p $sdk/native
    # What package.json's "files" publishes, without console/: the release puts a
    # prebuilt web console there, which nothing in the SDK reads.
    cp LICENSE $sdk/
    (cd mesh/sdk/node && cp -r package.json index.js index.d.ts inference.js models.js \
      live-transcription.js memberships.js native-runtime.js README.md $sdk/)
    install -Dm755 target/*/release/libmesh_llm_nodejs${stdenv.hostPlatform.extensions.sharedLibrary} \
      $sdk/native/mesh_llm_nodejs.node
    runHook postInstall
  '';

  # Some tests start an embedded node on 127.0.0.1.
  __darwinAllowLocalNetworking = true;
  # On Darwin, iroh's interface detection reads ICU data from the system, as for mesh-llm.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    nodejs
    writableTmpDirAsHomeHook
  ];
  # Upstream's test suite (npm test) against the installed package, which loads the addon.
  installCheckPhase = ''
    runHook preInstallCheck
    cp -r $out/lib/node_modules/@mesh-llm/sdk $TMPDIR/sdk
    chmod -R u+w $TMPDIR/sdk
    cp -r mesh/sdk/node/test $TMPDIR/sdk/
    (cd $TMPDIR/sdk && node --test test/*.test.js)
    runHook postInstallCheck
  '';

  meta = {
    description = "Node.js and TypeScript SDK with the native addon for MeshLLM";
    longDescription = ''
      By default the SDK downloads upstream's prebuilt llama.cpp runtime, which
      doesn't run on NixOS. Set the variables in
      `mesh-llm.passthru.runtimeEnvironment` (`MESH_LLM_NATIVE_RUNTIME_BUNDLE_DIR`)
      to use the runtimes built by Nixpkgs instead.
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm/tree/main/mesh/sdk/node";
    inherit (skippy-native-runtime.meta) changelog;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
    inherit (skippy-native-runtime.meta) platforms;
  };
}
