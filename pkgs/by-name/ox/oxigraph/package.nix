{
  lib,
  apple-sdk_15,
  enablePython ? false,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  python3Packages,
  rustPlatform,
  stdenv,
}:
let
  features = [
    "rustls-webpki"
    "geosparql"
    "rdf-12"
  ];
  mkDerivation =
    if enablePython then python3Packages.buildPythonPackage else rustPlatform.buildRustPackage;
in
mkDerivation (finalAttrs: {
  pname = if enablePython then "pyoxigraph" else "oxigraph";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "oxigraph";
    repo = "oxigraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I5NI1IoK+FPCmUUcLdyzBao7tuB8XIycPYQ6slYCtJc=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) version src;
    pname = "oxigraph";
    hash = "sha256-QMbhtKoVa1fN6BQwAZfPelxCV5MCqodqpN7qHJs70KE=";
  };

  pyproject = true;

  buildInputs = lib.optionals (stdenv.hostPlatform.isDarwin && enablePython) [
    apple-sdk_15
  ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    installShellFiles
  ]
  ++ lib.optionals enablePython [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildAndTestSubdir = if enablePython then "python" else "cli";
  buildNoDefaultFeatures = true;
  buildFeatures = features;

  nativeCheckInputs = lib.optionals enablePython [
    python3Packages.pytestCheckHook
  ];

  pythonImportsCheck = [ "pyoxigraph" ];

  disabledTests = [
    "test_update_load"
  ];

  disabledTestPaths = [
    # These require network access
    "lints/test_spec_links.py"
    "lints/test_debian_compatibility.py"
    "oxrocksdb-sys/rocksdb/tools/block_cache_analyzer/block_cache_pysim_test.py"
    "oxrocksdb-sys/rocksdb/tools"
  ];

  # Man pages and autocompletion
  postInstall = lib.optionals (!enablePython) ''
    MAN_DIR="$(find target/*/release -name man)"
    installManPage "$MAN_DIR"/*.1
    COMPLETE_DIR="$(find target/*/release -name complete)"
    installShellCompletion --bash --name oxigraph.bash "$COMPLETE_DIR/oxigraph.bash"
    installShellCompletion --fish --name oxigraph.fish "$COMPLETE_DIR/oxigraph.fish"
    installShellCompletion --zsh --name _oxigraph "$COMPLETE_DIR/_oxigraph"
  '';

  cargoCheckNoDefaultFeatures = true;
  cargoCheckFeatures = features;

  meta = {
    homepage = "https://github.com/oxigraph/oxigraph";
    description = "SPARQL graph database";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      astro
      dadada
      tnias
      videl
    ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "oxigraph";
  };
})
