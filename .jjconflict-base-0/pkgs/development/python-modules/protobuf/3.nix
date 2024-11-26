{
  buildPackages,
  buildPythonPackage,
  fetchpatch,
  isPyPy,
  lib,
  protobuf,
  pytestCheckHook,
  pythonAtLeast,
  tzdata,
}:

assert lib.versionAtLeast protobuf.version "3.21" -> throw "Protobuf 3.20 or older required";

buildPythonPackage {
  inherit (protobuf) pname src;

  version = protobuf.version;

  sourceRoot = "${protobuf.src.name}/python";

  patches = lib.optionals (pythonAtLeast "3.11") [
    (fetchpatch {
      name = "support-python311.patch";
      url = "https://github.com/protocolbuffers/protobuf/commit/2206b63c4649cf2e8a06b66c9191c8ef862ca519.diff";
      stripLen = 1; # because sourceRoot above
      hash = "sha256-3GaoEyZIhS3QONq8LEvJCH5TdO9PKnOgcQF0GlEiwFo=";
    })
  ];

  prePatch = ''
    if [[ "$(<../version.json)" != *'"python": "'"$version"'"'* ]]; then
      echo "Python library version mismatch. Derivation version: $version, actual: $(<../version.json)"
      exit 1
    fi
  '';

  # Remove the line in setup.py that forces compiling with C++14. Upstream's
  # CMake build has been updated to support compiling with other versions of
  # C++, but the Python build has not. Without this, we observe compile-time
  # errors using GCC.
  #
  # Fedora appears to do the same, per this comment:
  #
  #   https://github.com/protocolbuffers/protobuf/issues/12104#issuecomment-1542543967
  #
  postPatch = ''
    sed -i "/extra_compile_args.append('-std=c++14')/d" setup.py

    substituteInPlace google/protobuf/internal/json_format_test.py \
      --replace-fail assertRaisesRegexp assertRaisesRegex
  '';

  nativeBuildInputs = lib.optional isPyPy tzdata;

  buildInputs = [ protobuf ];

  propagatedNativeBuildInputs = [
    # For protoc of the same version.
    buildPackages."protobuf${lib.versions.major protobuf.version}_${lib.versions.minor protobuf.version}"
  ];

  setupPyGlobalFlags = [ "--cpp_implementation" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals isPyPy [
    # error message differs
    "testInvalidTimestamp"
    # requires tracemalloc which pypy does not implement
    # https://foss.heptapod.net/pypy/pypy/-/issues/3048
    "testUnknownFieldsNoMemoryLeak"
    # assertion is not raised for some reason
    "testStrictUtf8Check"
  ];

  pythonImportsCheck = [
    "google.protobuf"
    "google.protobuf.internal._api_implementation" # Verify that --cpp_implementation worked
  ];

  passthru = {
    inherit protobuf;
  };

  meta = with lib; {
    description = "Protocol Buffers are Google's data interchange format";
    homepage = "https://developers.google.com/protocol-buffers/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
