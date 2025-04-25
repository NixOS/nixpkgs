{
  lib,
  stdenv,
  cmake,
  eigen,
  fetchFromGitHub,
  gtest,
  gz-cmake,
  gz-utils,
  python3Packages,
  ruby,
  swig,
  withPython ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-math";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-math";
    tag = "gz-math${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-UpwgQrQrFuBe/ls9HtZy+UgO8b2ObHLCmCS6epEwOPo=";
  };

  nativeBuildInputs = [
    cmake
    gz-cmake
  ]
  ++ lib.optionals withPython [
    swig
  ];

  buildInputs = [
    gz-utils
    eigen
    ruby
    gtest
  ]
  ++ lib.optionals withPython [
    python3Packages.python
    python3Packages.pybind11
  ];

  cmakeFlags = [
    (lib.cmakeBool "SKIP_SWIG" (!withPython))
    (lib.cmakeBool "SKIP_PYBIND11" (!withPython))
  ];

  doCheck = true;

  nativeCheckInputs = [
    gtest
    ruby # Add Ruby to check inputs for the Ruby tests
  ]
  ++ lib.optionals withPython [
    python3Packages.pybind11
  ];

  postPatch = ''
    # Remove vendored gtest
    rm -rf test/gtest_vendor
    substituteInPlace test/CMakeLists.txt --replace-fail \
      "add_subdirectory(gtest_vendor)" "# add_subdirectory(gtest_vendor)"

    # Fix missing iomanip includes more carefully
    for file in src/*_TEST.cc; do
      if grep -q "std::setprecision" "$file" && ! grep -q "#include <iomanip>" "$file"; then
        sed -i '1i#include <iomanip>' "$file"
      fi
    done
  ''
  + lib.optionalString withPython ''
    # Remove vendored pybind11
    rm -rf src/python_pybind11
    substituteInPlace src/CMakeLists.txt --replace-fail \
      "add_subdirectory(python_pybind11)" "# add_subdirectory(python_pybind11)"
  ''
  + lib.optionalString (!withPython) ''
    # Properly comment out Python bindings
    sed -i '/if (SKIP_PYBIND11)/,/endif()/ {
      /if (SKIP_PYBIND11)/ s/^/# /
      /else()/,/endif()/ s/^/# /
    }' CMakeLists.txt

    # Comment out SWIG if present
    if grep -q "find_package(SWIG)" CMakeLists.txt; then
      substituteInPlace CMakeLists.txt --replace-fail \
        "find_package(SWIG QUIET)" \
        "# find_package(SWIG QUIET)"
    fi
  '';

  # Set up Ruby environment for tests - fixed syntax
  preCheck = ''
    export RUBYLIB="$out/lib/ruby/site_ruby/''${RUBY_VERSION}/:''${RUBYLIB}"
  '';

  outputs = [ "out" ] ++ lib.optionals withPython [ "python" ];

  postInstall = lib.optionalString withPython ''
    mkdir -p $python/${python3Packages.python.sitePackages}
    if [ -d "$out/lib/python" ]; then
      cp -r $out/lib/python*/* $python/${python3Packages.python.sitePackages}/
    fi
  '';

  meta = {
    description = "Math classes and functions for robot applications";
    homepage = "https://gazebosim.org/home";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
