# Static arguments
{
  lib,
  runCommandCC,
  cmake,
}:

# Tester arguments
{
  package,
  moduleNames,
  # Extra nativeBuildInputs needed to pass the cmake find_package test, e.g. pkg-config.
  nativeBuildInputs ? [ ],
  # buildInputs is used to help pass the cmake find_package test.
  # The purpose of buildInputs here is to allow us to iteratively add
  # any missing dependencies required by the *Config.cmake module
  # during testing. This allows us to test and fix the CMake setup
  # without rebuilding the finalPackage each time. Once all required
  # packages are properly added to the finalPackage's propagateBuildInputs,
  # this buildInputs should be set to an empty list [].
  buildInputs ? [ ],
  # Extra cmakeFlags needed to pass the cmake find_package test.
  # Can be used to set verbose/debug flags.
  cmakeFlags ? [ ],
  testName ? "check-cmake-config-${package.pname or package.name}",
  version ? package.version or null,
  versionCheck ? false,
}:

runCommandCC testName
  {
    inherit moduleNames versionCheck cmakeFlags;
    version = if versionCheck then version else null;
    nativeBuildInputs = [
      cmake
    ]
    ++ nativeBuildInputs;
    buildInputs = [ package ] ++ buildInputs;
    meta = {
      description = "Test whether ${package.name} exposes cmake-config modules ${lib.concatStringsSep ", " moduleNames}";
    }
    # Make sure licensing info etc is preserved, as this is a concern for e.g. cache.nixos.org,
    # as hydra can't check this meta info in dependencies.
    # The test itself is just Nixpkgs, with MIT license.
    // builtins.intersectAttrs {
      available = throw "unused";
      broken = throw "unused";
      insecure = throw "unused";
      license = throw "unused";
      maintainers = throw "unused";
      teams = throw "unused";
      platforms = throw "unused";
      unfree = throw "unused";
      unsupported = throw "unused";
    } package.meta;
  }
  ''
    touch "$out"
    notFound=0
    for moduleName in $moduleNames; do
      echo "checking cmake-config module $moduleName"

      cat <<EOF > CMakeLists.txt
    cmake_minimum_required(VERSION 3.14)
    project(CheckCmakeModule)

    find_package($moduleName $version EXACT NO_MODULE REQUIRED)
    EOF

      echoCmd 'cmake flags' $cmakeFlags
      set +e
      cmake . $cmakeFlags
      r=$?
      set -e
      if [[ $r = 0 ]]; then
        echo "✅ cmake-config module $moduleName exists"
      else
        echo "❌ cmake-config module $moduleName was not found"
        ((notFound+=1))
      fi
    done

    if [[ $notFound -ne 0 ]]; then
      exit 1
    fi
  ''
