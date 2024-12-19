{
  lib,
  stdenv,
  go,
  git,
  cacert,
}:

args:

let
  removedArgs = [
    "name"
    "pname"
    "version"
    "nativeBuildInputs"
    "hash"
  ];
in
stdenv.mkDerivation (
  {
    name = "${args.name or "${args.pname}-${args.version}"}-go-modules";

    nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [
      go
      git
      cacert
    ];

    inherit (go) GOOS GOARCH;
    GO111MODULE = "on";
    GOTOOLCHAIN = "local";

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

    buildPhase = ''
      runHook preBuild

      ${lib.optionalString args.deleteVendor ''
        if [ ! -d vendor ]; then
          echo "vendor folder does not exist, 'deleteVendor' is not needed"
          exit 10
        else
          rm -rf vendor
        fi
      ''}

      if [ -d vendor ]; then
        echo "vendor folder exists, please set 'vendorHash = null;' in your expression"
        exit 10
      fi

      export GIT_SSL_CAINFO=$NIX_SSL_CERT_FILE

      ${lib.optionalString args.proxyVendor ''
        mkdir -p "''${GOPATH}/pkg/mod/cache/download"
        go mod download
      ''}

      ${lib.optionalString (!args.proxyVendor) ''
        if (( "''${NIX_DEBUG:-0}" >= 1 )); then
          goModVendorFlags+=(-v)
        fi
        go mod vendor "''${goModVendorFlags[@]}"
      ''}

      mkdir -p vendor

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      ${lib.optionalString args.proxyVendor ''
        rm -rf "''${GOPATH}/pkg/mod/cache/download/sumdb"
        cp -r --reflink=auto "''${GOPATH}/pkg/mod/cache/download" $out
      ''}

      ${lib.optionalString (!args.proxyVendor) ''
        cp -r --reflink=auto vendor $out
      ''}

      if ! [ "$(ls -A $out)" ]; then
        echo "vendor folder is empty, please set 'vendorHash = null;' in your expression"
        exit 10
      fi

      runHook postInstall
    '';

    dontFixup = true;

    outputHashMode = "recursive";
    outputHash = args.hash;
    outputHashAlgo = if args.hash == "" then "sha256" else null;
  }
  // (lib.removeAttrs args removedArgs)
)
