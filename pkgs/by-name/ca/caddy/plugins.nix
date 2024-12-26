{
  lib,
  stdenv,
  go,
  xcaddy,
  cacert,
  git,
  caddy,
}:
{
  plugins,
  hash ? lib.fakeHash,
}:
let
  pluginsSorted = lib.sort lib.lessThan plugins;
  pluginsList = lib.concatMapStrings (plugin: "${plugin}-") pluginsSorted;
  pluginsHash = builtins.hashString "md5" pluginsList;
  pluginsWithoutVersion = lib.filter (p: !lib.hasInfix "@" p) pluginsSorted;
in
assert lib.assertMsg (
  lib.length pluginsWithoutVersion == 0
) "All plugins should have a version (eg ${lib.elemAt pluginsWithoutVersion 0}@x.y.z)!";
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
          withArgs = lib.concatMapStrings (plugin: "--with ${plugin} ") pluginsSorted;
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

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      ${lib.toShellVar "notfound" pluginsSorted}
      while read kind module version; do
        [[ "$kind" = "dep" ]] || continue
        module="''${module}@''${version}"
        for i in "''${!notfound[@]}"; do
          if [[ ''${notfound[i]} = ''${module} ]]; then
            unset 'notfound[i]'
          fi
        done
      done < <($out/bin/caddy build-info)
      if (( ''${#notfound[@]} )); then
        >&2 echo "Plugins not found: ''${notfound[@]}"
        exit 1
      fi

      runHook postInstallCheck
    '';
  }
)
