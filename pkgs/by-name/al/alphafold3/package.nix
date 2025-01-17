{
  lib,
  fetchFromGitHub,
  replaceVars,
  python3,
  abseil-cpp,
  dssp,
  libcifpp,
  pybind11-abseil,
  zlib,
  hmmer,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = final: prev: {
      typeguard = prev.typeguard.overridePythonAttrs (oldAttrs: rec {
        version = "2.13.3";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-AO2qjaOhM2dHls9eqH2fS0w2fXdHbhhegCUcwT37uMQ=";
        };
        doCheck = false;
      });
    };
  };
  libcifpp' = libcifpp.override { downloadCCDFile = true; };
in
python.pkgs.buildPythonApplication {
  pname = "alphafold3";
  version = "3.0.0-unstable-2024-12-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "alphafold3";
    rev = "b380a7c085a5eeea5117d2bd43c121e9a6e0df64";
    hash = "sha256-jgI7nCPlieNWShvFOfNVVjVh6eHj7J6cla2hV1apmm4=";
  };

  patches = [
    (replaceVars ./libcifpp.patch { libcifpp = libcifpp'; })
    ./add-shebang.patch
  ];

  build-system = with python.pkgs; [
    cmake
    ninja
    numpy
    pybind11
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    dssp
    libcifpp'
    zlib
  ];

  pypaBuildFlags = [
    "--config-setting=cmake.define.FETCHCONTENT_FULLY_DISCONNECTED=ON"
    "--config-setting=cmake.define.FETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    "--config-setting=cmake.define.FETCHCONTENT_SOURCE_DIR_ABSEIL-CPP=${abseil-cpp.src}"
    "--config-setting=cmake.define.FETCHCONTENT_SOURCE_DIR_PYBIND11_ABSEIL=${pybind11-abseil.src}"
  ];

  pythonRelaxDeps = true;

  # rdkit has no metadata
  pythonRemoveDeps = [ "rdkit" ];

  dependencies =
    with python.pkgs;
    [
      absl-py
      chex
      dm-haiku
      dm-tree
      jax
      jax-triton
      jaxtyping
      numpy
      rdkit
      tqdm
      triton
      typeguard
      zstandard
    ]
    ++ jax.optional-dependencies.cuda12;

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ hmmer ]}" ];

  postInstall = ''
    install -Dm755 run_alphafold.py -t $out/bin
  '';

  postFixup = ''
    $out/bin/build_data
  '';

  pythonImportsCheck = [ "alphafold3" ];

  # there are some tests, but they are difficult to run
  doCheck = false;

  meta = {
    description = "AlphaFold 3 inference pipeline";
    homepage = "https://github.com/google-deepmind/alphafold3";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "run_alphafold.py";
    # package size is too huge (> 900 MB) due to data
    hydraPlatforms = [ ];
  };
}
