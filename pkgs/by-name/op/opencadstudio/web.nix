{
  opencadstudio,

  binaryen,
  rustc,
  rustPlatform,
  trunk,
  wasm-bindgen-cli_0_2_108,
  zip,

  src,
  version,
  cargoHash,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opencadstudio-web";
  inherit version src cargoHash;

  __structuredAttrs = true;

  nativeBuildInputs = [
    binaryen # wasm-opt
    rustc.llvmPackages.lld
    trunk
    wasm-bindgen-cli_0_2_108
    zip
  ];

  buildPhase = ''
    runHook preBuild

    trunk build --offline --release

    runHook postBuild
  '';

  # already tested in opencadstudio
  doCheck = false;

  installPhase = ''
    runHook preInstall

    cd dist
    mkdir -p $out
    zip -r $out/web.zip *

    runHook postInstall
  '';

  meta = (removeAttrs opencadstudio.meta [ "mainProgram" ]) // {
    description = opencadstudio.meta.description + " (web)";
  };
})
