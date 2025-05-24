# Static arguments
{
  lib,
  runCommandCC,
  cmake,
  pkg-config,
}:

# Tester arguments
{
  package,
  moduleNames,
  testName ? "check-cmake-config-${package.pname or package.name}",
  version ? package.version or "",
  versionCheck ? false,
}:

runCommandCC testName
  {
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    buildInputs = [ package ];
    inherit moduleNames version versionCheck;
    meta =
      {
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

    cat <<EOF > CMakeLists.txt
    cmake_minimum_required(VERSION 3.14)
    project(CheckCmakeModule)

    EOF

    for moduleName in $moduleNames; do
      echo  "find_package($moduleName ${
        if versionCheck then version else ""
      } NO_MODULE REQUIRED)" >> CMakeLists.txt
    done

    cmake .
  ''
