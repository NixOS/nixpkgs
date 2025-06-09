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
  enablePython ? false,
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

  nativeBuildInputs =
    [
      cmake
      gz-cmake
    ]
    ++ lib.optionals enablePython [
      swig
    ];

  buildInputs =
    [
      gz-utils
      eigen
      ruby
    ]
    ++ lib.optional enablePython [
      python3Packages.python
      python3Packages.pybind11
    ];

  # Configure CMake flags based on Python support

  cmakeFlags = [
    (lib.cmakeBool "SKIP_SWIG" (!enablePython))
    (lib.cmakeBool "SKIP_PYBIND11" (!enablePython))
  ];

  doCheck = true;

  nativeCheckInputs =
    [
      gtest
    ]
    ++ lib.optional enablePython [
      python3Packages.pybind11
    ];

  postPatch =
    ''
      # Remove vendored gtest, use nixpkgs' version instead
      rm -r test/gtest_vendor
      substituteInPlace test/CMakeLists.txt --replace-fail \
          "add_subdirectory(gtest_vendor)" "# add_subdirectory(gtest_vendor)"

      # Fix missing iomanip header in test files that use std::setprecision
      for file in src/*_TEST.cc; do
        if grep -q "setprecision" "$file"; then
          sed -i '1i#include <iomanip>' "$file"
        fi
      done
    ''
    + lib.optionalString enablePython ''
      # Remove vendored pybind11 when Python is enabled, use nixpkgs' version instead
      rm -r src/python_pybind11
      substituteInPlace src/CMakeLists.txt --replace-fail \
          "add_subdirectory(python_pybind11)" "# add_subdirectory(python_pybind11)"
    ''
    + lib.optionalString (!enablePython) ''
          # When Python is disabled, patch CMakeLists.txt to skip Python detection
          # First, let's see what the actual content looks like
          echo "=== CMakeLists.txt around line 102-104 ==="
          sed -n '100,110p' CMakeLists.txt

          # Comment out the entire find_package lines properly
          sed -i 's/^find_package(Python3 COMPONENTS Interpreter)/# find_package(Python3 COMPONENTS Interpreter)/' CMakeLists.txt
          sed -i 's/^find_package(SWIG)/# find_package(SWIG)/' CMakeLists.txt

          # Also comment out any multi-line find_package calls
          sed -i '/^find_package(Python3/,/)/c\
      # find_package(Python3 COMPONENTS Interpreter) - disabled' CMakeLists.txt

          # Also patch src/CMakeLists.txt if it has Python-related content
          if [ -f src/CMakeLists.txt ]; then
            substituteInPlace src/CMakeLists.txt \
              --replace-fail "add_subdirectory(python_pybind11)" "# add_subdirectory(python_pybind11)"
          fi
    '';

  # Add Python outputs when enabled
  outputs = [ "out" ] ++ lib.optionals enablePython [ "python" ];

  # Install Python bindings to separate output
  postInstall = lib.optionalString enablePython ''
    mkdir -p $python/${python3Packages.python.sitePackages}

    # Check if Python files exist before trying to move them
    if [ -d "$out/lib" ]; then
      # Look for Python installation directories
      for pydir in $out/lib/python*; do
        if [ -d "$pydir" ]; then
          echo "Found Python directory: $pydir"
          cp -r "$pydir"/* "$python/${python3Packages.python.sitePackages}/" || true
        fi
      done

      # Also check for site-packages directly
      find "$out" -name "site-packages" -type d | while read -r spdir; do
        if [ -d "$spdir" ] && [ "$(ls -A "$spdir")" ]; then
          echo "Found site-packages: $spdir"
          cp -r "$spdir"/* "$python/${python3Packages.python.sitePackages}/"
        fi
      done
    fi

    # If no Python files were found, create an empty marker
    if [ ! "$(ls -A "$python/${python3Packages.python.sitePackages}" 2>/dev/null)" ]; then
      echo "No Python files found to install"
      touch "$python/${python3Packages.python.sitePackages}/.gz-math-python-placeholder"
    fi
  '';

  meta = {
    description = "Math classes and functions for robot applications";
    homepage = "https://gazebosim.org/home";
    downloadPage = "https://github.com/gazebosim/gz-math";
    changelog = "https://github.com/gazebosim/gz-math/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
