{
  abseil-cpp_202407,
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
  lib,
  pkg-config,
  protobuf_29,
  python3,
  re2,
  stdenv,
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
  abseil-cpp = abseil-cpp_202407;
  protobuf = protobuf_29.override { inherit abseil-cpp; };
  python-protobuf = python3.pkgs.protobuf5.override { inherit protobuf; };
  pybind11-protobuf = python3.pkgs.pybind11-protobuf.override { protobuf_29 = protobuf; };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "or-tools";
  version = "9.12";

  src = fetchFromGitHub {
    owner = "google";
    repo = "or-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5rFeAK51+BfjIyu/5f5ptaKMD7Hd20yHa2Vj3O3PkLU=";
  };

  patches = [
    # Rebased from https://build.opensuse.org/public/source/science/google-or-tools/0001-Do-not-try-to-copy-pybind11_abseil-status-extension-.patch?rev=19
    ./0001-Do-not-try-to-copy-pybind11_abseil-status-extension-.patch
    (fetchpatch {
      name = "0001-Revert-python-Fix-python-install-on-windows-breaks-L.patch";
      url = "https://build.opensuse.org/public/source/science/google-or-tools/0001-Revert-python-Fix-python-install-on-windows-breaks-L.patch?rev=19";
      hash = "sha256-BNB3KlgjpWcZtb9e68Jkc/4xC4K0c+Iisw0eS6ltYXE=";
    })
    (fetchpatch {
      name = "0001-Fix-up-broken-CMake-rules-for-bundled-pybind-stuff.patch";
      url = "https://build.opensuse.org/public/source/science/google-or-tools/0001-Fix-up-broken-CMake-rules-for-bundled-pybind-stuff.patch?rev=19";
      hash = "sha256-r38ZbRkEW1ZvJb0Uf56c0+HcnfouZZJeEYlIK7quSjQ=";
    })
    (fetchpatch {
      name = "math_opt-only-run-SCIP-tests-if-enabled.patch";
      url = "https://github.com/google/or-tools/commit/b5a2f8ac40dd4bfa4359c35570733171454ec72b.patch";
      hash = "sha256-h96zJkqTtwfBd+m7Lm9r/ks/n8uvY4iSPgxMZe8vtXI=";
    })
  ];

  # or-tools normally attempts to build Protobuf for the build platform when
  # cross-compiling. Instead, just tell it where to find protoc.
  postPatch = ''
    echo "set(PROTOC_PRG $(type -p protoc))" > cmake/host.cmake
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
    abseil-cpp
    bzip2
    cbc
    eigen
    glpk
    gbenchmark
    gtest
    highs
    python3.pkgs.absl-py
    python3.pkgs.pybind11
    python3.pkgs.pybind11-abseil
    pybind11-protobuf
    python3.pkgs.pytest
    python3.pkgs.scipy
    python3.pkgs.setuptools
    python3.pkgs.wheel
    re2
    zlib
  ];
  propagatedBuildInputs = [
    abseil-cpp
    highs
    protobuf
    python-protobuf
    python3.pkgs.immutabledict
    python3.pkgs.numpy
    python3.pkgs.pandas
  ]
  ++ lib.optionals withScip [
    # Needed for downstream cmake consumers to not need to set SCIP_ROOT explicitly
    scipopt-scip
  ];

  nativeCheckInputs = [
    python3.pkgs.matplotlib
    python3.pkgs.pandas
    python3.pkgs.pytest
    python3.pkgs.scipy
    python3.pkgs.svgwrite
    python3.pkgs.virtualenv
  ];

  # some tests fail on aarch64-linux and hang on darwin
  doCheck = stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux;

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/lib
  '';

  # This extra configure step prevents the installer from littering
  # $out/bin with sample programs that only really function as tests,
  # and disables the upstream installation of a zipped Python egg that
  # can’t be imported with our Python setup.
  installPhase = ''
    cmake . -DBUILD_EXAMPLES=OFF -DBUILD_PYTHON=OFF -DBUILD_SAMPLES=OFF
    cmake --install .
    pip install --prefix="$python" python/
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
  };
})
