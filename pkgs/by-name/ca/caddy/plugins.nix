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

      declare -A modules errors
      ${toShellVar "notfound" pluginsSorted}

      # put build info that we care about into `modules` list
      while read -r kind module version _; do
        case "$kind" in
          'dep'|'=>')
            modules[$module]=$version
            ;;
          *)
            # we only care about 'dep' and '=>' directives for now
            ;;
        esac
      done < <($out/bin/caddy build-info)

      # compare build-time (Nix side) against runtime (Caddy side)
      for spec in "''${notfound[@]}"; do
        if [[ $spec == *=* ]]; then
            # orig=repl_mod@repl_ver
            orig=''${spec%%=*}
            repl=''${spec#*=}
            repl_mod=''${repl%@*}
            repl_ver=''${repl#*@}

            if [[ -z ''${modules[$orig]} ]]; then
                errors[$spec]="plugin \"$spec\" with replacement not found in build info:\n  reason: \"$orig\" missing"
            elif [[ -z ''${modules[$repl_mod]} ]]; then
                errors[$spec]="plugin \"$spec\" with replacement not found in build info:\n  reason: \"$repl_mod\" missing"
            elif [[ "''${modules[$repl_mod]}" != "$repl_ver" ]]; then
                errors[$spec]="plugin \"$spec\" have incorrect tag:\n  specified: \"$spec\"\n  got: \"$orig=$repl_mod@''${modules[$repl_mod]}\""
            fi
        else
          # mod@ver
          mod=''${spec%@*}
          ver=''${spec#*@}

          if [[ -z ''${modules[$mod]} ]]; then
              errors[$spec]="plugin \"$spec\" not found in build info"
          elif [[ "''${modules[$mod]}" != "$ver" ]]; then
              errors[$spec]="plugin \"$spec\" have incorrect tag:\n  specified: \"$spec\"\n  got: \"$mod@''${modules[$mod]}\""
          fi
        fi
      done

      # print errors if any
      if [[ ''${#errors[@]} -gt 0 ]]; then
        for spec in "''${!errors[@]}"; do
          printf "Error: ''${errors[$spec]}\n" >&2
        done

        echo "Tips:"
        echo "If:"
        echo "  - you are using module replacement (e.g. \`plugin1=plugin2@version\`)"
        echo "  - the provided Caddy plugin is under a repository's subdirectory, and \`go.{mod,sum}\` files are not in that subdirectory"
        echo "  - you have custom build logic or other advanced use cases"
        echo "Please consider:"
        echo "  - set \`doInstallCheck = false\`"
        echo "  - write your own \`installCheckPhase\` and override the default script"
        echo "If you are sure this error is caused by packaging, or by caddy/xcaddy, raise an issue with upstream or nixpkgs"

        exit 1
      fi

      runHook postInstallCheck
    '';
  }
)
