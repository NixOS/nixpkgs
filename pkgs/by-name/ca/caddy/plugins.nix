# callPackage args
{
  lib,
  stdenv,
  go,
  xcaddy,
  cacert,
  git,
  caddy,
}:

let
  inherit (builtins) hashString;
  inherit (lib)
    assertMsg
    concatMapStrings
    elemAt
    fakeHash
    filter
    hasInfix
    length
    lessThan
    sort
    toShellVar
    ;
in

# pkgs.caddy.withPlugins args
{
  plugins,
  hash ? fakeHash,
  doInstallCheck ? true,
}:

let
  pluginsSorted = sort lessThan plugins;
  pluginsList = concatMapStrings (plugin: "${plugin}-") pluginsSorted;
  pluginsHash = hashString "md5" pluginsList;
  pluginsWithoutVersion = filter (p: !hasInfix "@" p) pluginsSorted;
in

# eval barrier: user provided plugins must have tags
# the go module must either be tagged in upstream repo
# or user must provide commit sha or a pseudo-version number
# https://go.dev/doc/modules/version-numbers#pseudo-version-number
assert assertMsg (
  length pluginsWithoutVersion == 0
) "Plugins must have tags present (e.g. ${elemAt pluginsWithoutVersion 0}@x.y.z)!";

caddy.overrideAttrs (
  finalAttrs: prevAttrs: {
    vendorHash = null;
    subPackages = [ "." ];

    src = stdenv.mkDerivation {
      pname = "caddy-src-with-plugins-${pluginsHash}";
      version = finalAttrs.version;

      nativeBuildInputs = [
        go
        xcaddy
        cacert
        git
      ];
      dontUnpack = true;
      buildPhase =
        let
          withArgs = concatMapStrings (plugin: "--with ${plugin} ") pluginsSorted;
        in
        ''
          export GOCACHE=$TMPDIR/go-cache
          export GOPATH="$TMPDIR/go"
          XCADDY_SKIP_BUILD=1 TMPDIR="$PWD" xcaddy build v${finalAttrs.version} ${withArgs}
          (cd buildenv* && go mod vendor)
        '';
      installPhase = ''
        mv buildenv* $out
      '';

      outputHashMode = "recursive";
      outputHash = hash;
      outputHashAlgo = "sha256";
    };

    # xcaddy built output always uses pseudo-version number
    # we enforce user provided plugins are present and have matching tags here
    inherit doInstallCheck;
    installCheckPhase = ''
      runHook preInstallCheck

      ${toShellVar "notfound" pluginsSorted}

      local build_info_output
      build_info_output=$($out/bin/caddy build-info)

      while read -r kind module version rest; do
        if [[ "$kind" != "dep" && "$kind" != "=>" ]]; then
          continue
        fi

        if [[ -z "$module" || -z "$version" ]]; then
          continue
        fi

        local module_from_build="''${module}@''${version}"

        for i in "''${!notfound[@]}"; do
          local user_plugin="''${notfound[i]}"
          local expected_in_build="$user_plugin"

          if [[ "$user_plugin" == *"="* ]]; then
            expected_in_build="''${user_plugin#*=}"
          fi

          if [[ "$expected_in_build" == "$module_from_build" ]]; then
            unset 'notfound[i]'
            break
          fi
        done
      done < <(echo "$build_info_output")

      if (( ''${#notfound[@]} )); then
        for plugin in "''${notfound[@]}"; do
          if [[ "$plugin" == *"="* ]]; then
            echo "Plugin with alias \"$plugin\" not found in build:"
            echo "  specified: \"$plugin\""
            echo "  The check looks for the replacement module \"''${plugin#*=}\" in the build output."
            echo "  This replacement module was not found:"
            echo "  - if you are using `go.mod` alias or other advanced usage(s), set `doInstallCheck = false` or write your own `installCheckPhase` in `caddy.withPlugins` call"
            echo "  - if you are sure this error is caused by packaging, or caused by caddy/xcaddy, raise an issue with nixpkgs or upstream"
          else
            local base=''${plugin%@*}
            local specified=''${plugin#*@}
            local found=0

            while read -r kind module expected rest; do
              if [[ ("$kind" = "dep" || "$kind" = "=>") && "$module" = "$base" ]]; then
                echo "Plugin \"$base\" have incorrect tag:"
                echo "  specified: \"$base@$specified\""
                echo "  got: \"$base@$expected\""
                found=1
                break
              fi
            done < <(echo "$build_info_output")

            if (( found == 0 )); then
              echo "Plugin \"$base\" not found in build:"
              echo "  specified: \"$base@$specified\""
              echo "  plugin does not exist in the xcaddy build output:"
              echo "  - if you are using `go.mod` alias or other advanced usage(s), set `doInstallCheck = false` or write your own `installCheckPhase` in `caddy.withPlugins` call"
              echo "  - if you are sure this error is caused by packaging, or caused by caddy/xcaddy, raise an issue with nixpkgs or upstream"
            fi
          fi
        done

        exit 1
      fi

      runHook postInstallCheck
    '';
  }
)
