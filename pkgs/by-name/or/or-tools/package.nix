{
  abseil-cpp,
  bzip2,
  cbc,
  cmake,
  eigen,
  ensureNewerSourcesForZipFilesHook,
  fetchFromGitHub,
  fetchpatch,
  glpk,
  highs,
  lib,
  pkg-config,
  protobuf,
  python3,
  re2,
  stdenv,
  swig,
  unzip,
  zlib,
}:

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
  ];

  # or-tools normally attempts to build Protobuf for the build platform when
  # cross-compiling. Instead, just tell it where to find protoc.
  postPatch =
    ''
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

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_DEPS" false)
      (lib.cmakeBool "BUILD_PYTHON" true)
      (lib.cmakeBool "BUILD_pybind11" false)
      (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
      (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
      (lib.cmakeBool "FETCH_PYTHON_DEPS" false)
      (lib.cmakeBool "USE_GLPK" true)
      (lib.cmakeBool "USE_SCIP" false)
      (lib.cmakeFeature "Python3_EXECUTABLE" "${python3.pythonOnBuildForHost.interpreter}")
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.cmakeBool "CMAKE_MACOSX_RPATH" false)
    ];

  strictDeps = true;

  nativeBuildInputs =
    [
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
    highs
    python3.pkgs.absl-py
    python3.pkgs.pybind11
    python3.pkgs.pybind11-abseil
    python3.pkgs.pybind11-protobuf
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
    python3.pkgs.protobuf
    python3.pkgs.immutabledict
    python3.pkgs.numpy
    python3.pkgs.pandas
  ];
  nativeCheckInputs = [
    python3.pkgs.matplotlib
    python3.pkgs.virtualenv
  ];

  # some tests fail on linux and hang on darwin
  doCheck = false;

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
