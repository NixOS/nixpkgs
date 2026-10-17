{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchgit,
  cmake,
  openblas,
  boost186,
  python3,
  python3Packages,
  protobuf_21,
}:

let
  onnx-protofile = (
    stdenv.mkDerivation {
      name = "onnx-protofile";
      src = fetchFromGitHub {
        owner = "onnx";
        repo = "onnx";
        rev = "v1.15.0";
        sparseCheckout = [
          "onnx/"
        ];
        hash = "sha256-sRHeYo/3GWkzeHxq31Lshk5EpFl/HZOnLmtl/PXONtU=";
      };
      installPhase = ''
        mkdir $out
        mv onnx/onnx.proto3 $out/onnx.proto3
      '';
    }
  );
in
stdenv.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "Marabou";
  version = "2.0";
  src = fetchgit {
    url = "https://github.com/NeuralNetworkVerification/Marabou.git";
    rev = "v2.0.0";
    sha256 = "sha256-Bplaq1T+3KPA9Cykzk9Zxje4KQscYDTrDY2rdYlO2E0=";
    fetchSubmodules = true;
  };
  buildInputs = [
    boost186
    openblas
  ];
  nativeBuildInputs = [
    cmake
    python3
    python3Packages.pybind11
    python3Packages.pythonImportsCheckHook
    protobuf_21
    onnx-protofile
  ];
  # Regression tests are disabled because of python imports errors
  cmakeFlags = [
    "-DBUILD_PYTHON=OFF"
    "-DPROTOBUF_DIR=${protobuf_21}"
    "-DOPENBLAS_DIR=${openblas}"
  ];
  # Generating ourselves the onnx proto header, preempting CMake
  # Assuming onnx revision is vX.YY.Z
  prePatch = ''
    export ONNX_VERSION=$(echo "${onnx-protofile.src.rev}" | tr -d v)
    mkdir -p tools/onnx-$ONNX_VERSION
    ${protobuf_21}/bin/protoc --proto_path=${onnx-protofile} --cpp_out=tools/onnx-$ONNX_VERSION ${onnx-protofile}/onnx.proto3
  '';
  # Patches:
  # - cxx tests to use python3 constructs
  # - cmake paths to comply with nix conventions
  patches = [
    ./cmake.patch
    ./python3-cxx-tests.patch
  ];
  installPhase = ''
    mkdir -p $out/bin
    mv Marabou $out/bin/
  '';

  meta = {
    homepage = "https://github.com/NeuralNetworkVerification/Marabou";
    description = "Marabou is an SMT-based tool for formal verification of
    neural networks.";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GirardR1006 ];
  };
}
