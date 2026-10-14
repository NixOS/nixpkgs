{
  opencadstudio,

  binaryen,
  fetchpatch,
  rustc,
  rustPlatform,
  trunk,
  wasm-bindgen-cli_0_2_108,
  zip,
}:
let
  wasm-bindgen-cli = wasm-bindgen-cli_0_2_108;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opencadstudio-web";
  inherit (opencadstudio) version src cargoHash;

  patches = [
    (fetchpatch {
      url = "https://github.com/HakanSeven12/OpenCADStudio/commit/23617c62a62c1aea17c6755e28738f0cd6e9c95c.patch";
      hash = "sha256-erebs6fR5FfbJ9ddvD9OXg5qkjf3XVZNXyKLG3zMdc4=";
      name = "23617c6-proj4wkt-native-only.patch";
    })
  ];

  __structuredAttrs = true;

  nativeBuildInputs = [
    binaryen # wasm-opt
    rustc.llvmPackages.lld
    trunk
    wasm-bindgen-cli
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
