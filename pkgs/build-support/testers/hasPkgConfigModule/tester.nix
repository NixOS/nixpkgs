# Static arguments
{ runCommand, pkg-config }:

# Tester arguments
{ package,
  moduleName,
  testName ? "check-pkg-config-${moduleName}",
}:

runCommand testName {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ package ];
    inherit moduleName;
    meta = {
      description = "Test whether ${package.name} exposes pkg-config module ${moduleName}";
    }
    # Make sure licensing info etc is preserved, as this is a concern for e.g. cache.nixos.org,
    # as hydra can't check this meta info in dependencies.
    # The test itself is just Nixpkgs, with MIT license.
    // builtins.intersectAttrs
        {
          available = throw "unused";
          broken = throw "unused";
          insecure = throw "unused";
          license = throw "unused";
          maintainers = throw "unused";
          platforms = throw "unused";
          unfree = throw "unused";
          unsupported = throw "unused";
        }
        package.meta;
  } ''
    echo "checking pkg-config module $moduleName in $buildInputs"
    set +e
    version="$(pkg-config --modversion $moduleName)"
    r=$?
    set -e
    if [[ $r = 0 ]]; then
      echo "✅ pkg-config module $moduleName exists and has version $version"
      echo "$version" > $out
    else
      echo "These modules were available in the input propagation closure:"
      pkg-config --list-all
      echo "❌ pkg-config module $moduleName was not found"
      false
    fi
  ''
