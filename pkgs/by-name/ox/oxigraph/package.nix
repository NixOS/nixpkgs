{
  lib,
  apple-sdk_15,
  buildPythonPackage ? null,
  enablePython ? false,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  pythonPackages ? null,
  rustPlatform,
  stdenv,
}:
assert enablePython -> buildPythonPackage != null;
assert enablePython -> pythonPackages != null;
let
  features = [
    "rustls-webpki"
    "geosparql"
    "rdf-12"
  ];
  mkDerivation =
    if isNull buildPythonPackage then rustPlatform.buildRustPackage else buildPythonPackage;
in
mkDerivation (finalAttrs: {
  pname = "oxigraph";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "oxigraph";
    repo = "oxigraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J4cx/fzdsgRXeWsP9Gt5q/0crWoc1OP8+xbuvQJTj34=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-BvL1rGJcU28TLkxJ3pKah6qfaa0SdUt143UgBYJrLsE=";
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
    pythonPackages.pythonImportsCheckHook
    pythonPackages.pytestCheckHook
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
    ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "oxigraph";
  };
})
