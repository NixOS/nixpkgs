# Static arguments
{
  lib,
  runCommand,
  pkg-config,
}:

# Tester arguments
{
  package,
  moduleNames ? package.meta.pkgConfigModules,
  testName ? "check-pkg-config-${lib.concatStringsSep "-" moduleNames}",
  version ? package.version or null,
  versionCheck ? false,
}:

runCommand testName
  {
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ package ];
    inherit moduleNames version versionCheck;
    meta =
      {
        description = "Test whether ${package.name} exposes pkg-config modules ${lib.concatStringsSep ", " moduleNames}";
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
        platforms = throw "unused";
        unfree = throw "unused";
        unsupported = throw "unused";
      } package.meta;
  }
  ''
    touch "$out"
    notFound=0
    versionMismatch=0
    for moduleName in $moduleNames; do
      echo "checking pkg-config module $moduleName in $buildInputs"
      set +e
      moduleVersion="$($PKG_CONFIG --modversion $moduleName)"
      r=$?
      set -e
      if [[ $r = 0 ]]; then
        if [[ "$moduleVersion" == "$version" ]]; then
          echo "✅ pkg-config module $moduleName exists and has version $moduleVersion"
        else
          echo "${
            if versionCheck then "❌" else "ℹ️"
          } pkg-config module $moduleName exists at version $moduleVersion != $version (drv version)"
          ((versionMismatch+=1))
        fi
        printf '%s\t%s\n' "$moduleName" "$version" >> "$out"
      else
        echo "❌ pkg-config module $moduleName was not found"
        ((notFound+=1))
      fi
    done

    if [[ $notFound -eq 0 ]] && ([[ $versionMismatch -eq 0 ]] || [[ -z "$versionCheck" ]]); then
      exit 0
    fi
    if [[ $notFound -ne 0 ]]; then
      echo "$notFound modules not found"
      echo "These modules were available in the input propagation closure:"
      $PKG_CONFIG --list-all
    fi
    if [[ $versionMismatch -ne 0 ]]; then
      echo "$versionMismatch version mismatches"
    fi
    exit 1
  ''
