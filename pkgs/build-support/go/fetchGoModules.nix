{
  go,
  cacert,
  gitMinimal,
  lib,
  stdenv,
}:

lib.fetchers.withNormalizedHash { } (
  {
    outputHash,
    outputHashAlgo,

    pname ? null,
    version ? null,

    # The go.sum file to track which can cause rebuilds.
    goSum ? null,

    name ?
      let
        prefix =
          if pname != null && version != null then
            "${pname}-${version}-"
          else
            throw "fetchGoModules requires either a `name`, or both `pname` and `version`";

        # If "goSum" is supplied then it can cause the vendor directory to rebuild.
        # Attach the hash name of the "go.sum" file so we can rebuild when it changes.
        suffix = lib.optionalString (
          goSum != null
        ) "-${(lib.removeSuffix "-go.sum" (lib.removePrefix "${builtins.storeDir}/" goSum))}";
      in
      "${prefix}go-modules${suffix}",

    # Directory to the `go.mod` and `go.sum` relative to the `src`.
    modRoot ? "./",

    # Whether to delete the vendor folder supplied with the source.
    deleteVendor ? false,

    # Whether to fetch (go mod download) and proxy the vendor directory.
    proxyVendor ? false,

    nativeBuildInputs ? [ ],

    ...
  }@args:

  let
    removedArgs = [
      "pname"
      "version"
      "goSum"
      "name"
      "modRoot"
      "deleteVendor"
      "proxyVendor"
      "nativeBuildInputs"
    ];
  in

  stdenv.mkDerivation (
    {
      inherit name goSum modRoot;

      nativeBuildInputs = nativeBuildInputs ++ [
        go
        gitMinimal
        cacert
      ];

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
        "GOPROXY"
      ];

      configurePhase = ''
        runHook preConfigure
        export GOCACHE=$TMPDIR/go-cache
        export GOPATH="$TMPDIR/go"
        cd "$modRoot"
        runHook postConfigure
      '';

      buildPhase = (
        ''
          runHook preBuild
        ''
        + lib.optionalString deleteVendor ''
          if [ ! -d vendor ]; then
            echo "vendor folder does not exist, 'deleteVendor' is not needed"
            exit 10
          else
            rm -rf vendor
          fi
        ''
        + ''
          if [ -d vendor ]; then
            echo "vendor folder exists, please set 'vendorHash = null;' in your expression"
            exit 10
          fi

          export GIT_SSL_CAINFO=$NIX_SSL_CERT_FILE
          ${
            if proxyVendor then
              ''
                mkdir -p "$GOPATH/pkg/mod/cache/download"
                go mod download
              ''
            else
              ''
                if (( "''${NIX_DEBUG:-0}" >= 1 )); then
                  goModVendorFlags+=(-v)
                fi
                go mod vendor "''${goModVendorFlags[@]}"
              ''
          }

          mkdir -p vendor

          runHook postBuild
        ''
      );

      installPhase = ''
        runHook preInstall

        ${
          if proxyVendor then
            ''
              rm -rf "$GOPATH/pkg/mod/cache/download/sumdb"
              cp -r --reflink=auto "$GOPATH/pkg/mod/cache/download" $out
            ''
          else
            ''
              cp -r --reflink=auto vendor $out
            ''
        }

        if ! [ "$(ls -A $out)" ]; then
          echo "vendor folder is empty, please set 'vendorHash = null;' in your expression"
          exit 10
        fi

        runHook postInstall
      '';

      dontFixup = true;

      outputHashMode = "recursive";
    }
    // removeAttrs args removedArgs
  )
)
