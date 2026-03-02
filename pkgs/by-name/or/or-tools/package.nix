{
  stdenv,
  lib,
  callPackage,

  abseil-cpp_202508,
  bzip2,
  cbc,
  cmake,
  eigen,
  ensureNewerSourcesForZipFilesHook,
  fetchFromGitHub,
  fetchpatch,
  gtest,
  gbenchmark,
  glpk,
  highs,
  pkg-config,
  protobuf_32,
  protobuf-matchers,
  python3,
  re2,
  swig,
  unzip,
  zlib,

  scipopt-scip,
  withScip ? true,
}:

let
  # OR-Tools strictly requires specific versions of abseil-cpp and
  # protobuf. Do not un-pin these, even if you're upgrading them to
  # what might happen to be the latest version at the current moment;
  # future upgrades *will* break the build.
  abseil-cpp' = abseil-cpp_202508;
  gtest' = gtest.override {
    withAbseil = true;
    abseil-cpp = abseil-cpp';
  };
  protobuf' = protobuf_32.override { abseil-cpp = abseil-cpp'; };
  protobuf-matchers' = protobuf-matchers.override { protobuf = protobuf'; };
  python-protobuf' = python3.pkgs.protobuf6.override { protobuf = protobuf'; };

  pybind11' = callPackage ./pybind11-2.13.6.nix {
    inherit (python3.pkgs)
      buildPythonPackage
      cmake
      ninja
      numpy
      pytestCheckHook
      setuptools
      ;
    python = python3;
  };
  pybind11-abseil' = python3.pkgs.pybind11-abseil.override {
    pybind11 = pybind11';
    abseil-cpp = abseil-cpp';
  };
  pybind11-protobuf' = callPackage ./pybind11-protobuf.nix {
    inherit (python3.pkgs) buildPythonPackage;
    pybind11 = pybind11';
  };
  # re2 must also use the same abseil version, else these two versions will conflict during linking
  re2' = re2.override { abseil-cpp = abseil-cpp'; };

  # 77a28070b9c4c83995ac6bbfa9544722ff3342ce renamed the scip cmake target(s) differently
  # to what upstream still calls it. Apply this patch to scipopt-scip.
  scipopt-scip' = scipopt-scip.overrideAttrs (old: {
    patches = old.patches or [ ] ++ [
      # from https://github.com/google/or-tools/commit/77a28070b9c4c83995ac6bbfa9544722ff3342ce#diff-c95174a817e73db366d414af1e329c1856f70e5158ed3994d43da88765ccc98f
      # and updated with https://github.com/google/or-tools/pull/4932/files#diff-e6b0a69b2e4b97ec922abc459d909483d440a1e0d2868bed263927b106b6efe6
      ./scip.patch
    ];
    # Their patch forgets to find_package() soplex, bring it back.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'message(STATUS "Finding Soplex")' 'find_package(SOPLEX CONFIG HINTS ''${SOPLEX_DIR})'
    '';
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "or-tools";
  version = "9.15";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9+tvgP/+/VY6wu7lzTdP4xfiJIgPSLVR9lEdZjQCZkE=";
  };

  patches = [
    # Rebased from https://build.opensuse.org/public/source/science/google-or-tools/0001-Do-not-try-to-copy-pybind11_abseil-status-extension-.patch?rev=19
    ./0001-Do-not-try-to-copy-pybind11_abseil-status-extension-.patch
    (fetchpatch {
      name = "0001-Revert-python-Fix-python-install-on-windows-breaks-L.patch";
      url = "https://build.opensuse.org/public/source/science/google-or-tools/0001-Revert-python-Fix-python-install-on-windows-breaks-L.patch?rev=19";
      hash = "sha256-BNB3KlgjpWcZtb9e68Jkc/4xC4K0c+Iisw0eS6ltYXE=";
    })
    ./0001-Fix-up-broken-CMake-rules-for-bundled-pybind-stuff.patch
  ];

  # or-tools normally attempts to build Protobuf for the build platform when
  # cross-compiling. Instead, just tell it where to find protoc.
  postPatch = ''
    echo "set(PROTOC_PRG $(type -p protoc))" > cmake/host.cmake
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(BUILD_protobuf_matchers ON)' 'set(BUILD_protobuf_matchers OFF)'
  ''
  # Patches from OpenSUSE:
  # https://build.opensuse.org/projects/science/packages/google-or-tools/files/google-or-tools.spec?expand=1
  + ''
    sed -i -e '/CMAKE_DEPENDENT_OPTION(INSTALL_DOC/ s/BUILD_CXX AND BUILD_DOC/BUILD_CXX/' CMakeLists.txt
    find . -iname \*CMakeLists.txt -exec sed -i -e 's/pybind11_native_proto_caster/pybind11_protobuf::pybind11_native_proto_caster/' '{}' \;
    sed -i -e 's/TARGET pybind11_native_proto_caster/TARGET pybind11_protobuf::pybind11_native_proto_caster/' cmake/check_deps.cmake
    sed -i -e "/protobuf/ { s/.*,/'protobuf >= 5.26',/ }" ortools/python/setup.py.in
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DEPS" false)
    (lib.cmakeBool "BUILD_PYTHON" true)
    (lib.cmakeBool "BUILD_pybind11" false)
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeBool "FETCH_PYTHON_DEPS" false)
    # not packaged in nixpkgs
    (lib.cmakeBool "USE_GLPK" true)
    (lib.cmakeBool "USE_SCIP" withScip)
    (lib.cmakeFeature "Python3_EXECUTABLE" "${python3.pythonOnBuildForHost.interpreter}")
  ]
  ++ lib.optionals withScip [
    # scip code parts require setting this unfortunately…
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-error=format-security")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "CMAKE_MACOSX_RPATH" false)
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ensureNewerSourcesForZipFilesHook
    pkg-config
    python3.pythonOnBuildForHost
    swig
    unzip
  ]
  ++ (with python3.pythonOnBuildForHost.pkgs; [
    pip
    mypy-protobuf
    mypy
  ]);
  buildInputs = [
    abseil-cpp'
    bzip2
    cbc
    eigen
    glpk
    gbenchmark
    gtest'
    highs
    protobuf-matchers'
    python3.pkgs.absl-py
    pybind11'
    pybind11-abseil'
    pybind11-protobuf'
    python3.pkgs.pytest
    python3.pkgs.scipy
    python3.pkgs.setuptools
    python3.pkgs.wheel
    re2'
    zlib
  ];
  propagatedBuildInputs = [
    abseil-cpp'
    highs
    protobuf'
    python-protobuf'
    python3.pkgs.immutabledict
    python3.pkgs.numpy
    python3.pkgs.pandas
  ]
  ++ lib.optionals withScip [
    # Needed for downstream cmake consumers to not need to set SCIP_ROOT explicitly
    scipopt-scip'
  ];

  nativeCheckInputs = [
    python3.pkgs.matplotlib
    python3.pkgs.pandas
    python3.pkgs.pytest
    python3.pkgs.scipy
    python3.pkgs.svgwrite
    python3.pkgs.virtualenv
  ];

  # some tests hang on darwin
  doCheck = stdenv.hostPlatform.isLinux;

  preCheck = ''
    patchShebangs examples/python
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/lib
  '';

  # This extra configure step prevents the installer from littering
  # $out/bin with sample programs that only really function as tests,
  # and disables the upstream installation of a zipped Python egg that
  # can’t be imported with our Python setup.
  installPhase = ''
    cmake . -DBUILD_EXAMPLES=OFF -DBUILD_PYTHON=OFF -DBUILD_SAMPLES=OFF
    cmake --install .

    # Install the Python bindings.
    # --no-build-isolation: Required because Nix provides build tools (setuptools/wheel)
    #   locally; without this, pip tries to download them from the internet.
    # --no-index: Prevents pip from searching PyPI for packages.
    pip install --no-index --no-build-isolation --prefix="$python" python/
  '';

  outputs = [
    "out"
    "python"
  ];

  meta = {
    homepage = "https://github.com/google/or-tools";
    license = lib.licenses.asl20;
    description = ''
      Google's software suite for combinatorial optimization.
    '';
    mainProgram = "fzn-cp-sat";
    maintainers = with lib.maintainers; [ andersk ];
    platforms = with lib.platforms; linux ++ darwin;

    # Only version 9.15 adds support for Python 3.14: https://github.com/google/or-tools/releases/tag/v9.15
    # Also this package is tied to pybind 2.13.6, and only 3.0.0 supports Python 3.14: https://github.com/pybind/pybind11/releases/tag/v3.0.0
    # Also, nix review fails to build python314Packages.ortools
    broken = python3.pythonAtLeast "3.14";
  };
})
