{ lib, stdenvNoCC, makeWrapper, nodejs }:

{ src
, hash ? ""
, sha256 ? ""
, name ? null
, production ? true
, runScripts ? false
, makeTarball ? true
, preferLocalBuild ? true
, npmFlags ? ""
, ...
} @ args:

let
  suffix = if makeTarball then ".tar.gz" else "";
  prodSuffix = if production then "-production" else "-dev";
  name_ = if name == null then "${src.name}-node_modules${prodSuffix}${suffix}" else name;
  nodejs_ = if args ? nodejs then args.nodejs else nodejs;

  hash_ =
    if hash != "" then { outputHashAlgo = null; outputHash = hash; }
    else if sha256 != "" then { outputHashAlgo = "sha256"; outputHash = sha256; }
    else throw "fetchNodeModules requires a hash for ${name_}";

  customArgs = [ "name" "hash" "sha256" ];
in stdenvNoCC.mkDerivation ({
  inherit src production runScripts makeTarball preferLocalBuild;

  name = name_;
  nativeBuildInputs = [ nodejs_ makeWrapper ];

  phases = "unpackPhase patchPhase buildPhase installPhase";

  buildPhase = ''
    if [[ ! -f package.json ]]; then
        echo
        echo "ERROR: The package.json file doesn't exist"
        echo
        exit 1
    fi
    if [[ ! -f package-lock.json ]]; then
        echo
        echo "ERROR: The package-lock.json file doesn't exist"
        echo
        echo "package-lock.json is required to make sure the node_modules"
        echo "set we download never changes."
        exit 1
    fi

    export SOURCE_DATE_EPOCH=1
    export npm_config_cache=/tmp
    NPM_FLAGS="--no-update-notifier $npmFlags"

    # Scripts may result in non-deterministic behavior.
    # Some packages (e.g., Puppeteer) use postinstall scripts to download extra data.
    if [[ -z $runScripts ]]; then
        NPM_FLAGS+=" --ignore-scripts"
    fi

    # Whether to install dev dependencies
    if [[ -n $production ]]; then
        NPM_FLAGS+=" --production"
    fi

    echo "Running npm ci $NPM_FLAGS"
    npm ci $NPM_FLAGS

    echo "Injecting package manifest into output"
    cp package.json node_modules/
    cp package-lock.json node_modules/
  '';

  installPhase = ''
    if [[ -n $makeTarball ]]; then
        # Produce a deterministic tarball
        tar -czf $out --owner=0 --group=0 --numeric-owner --format=gnu \
            --mtime="@$SOURCE_DATE_EPOCH" --sort=name \
            node_modules
    else
        # Copy all modules into a directory
        mkdir -p $out/lib
        cp -r node_modules $out/lib
    fi
  '';

  outputHashMode = if makeTarball then "flat" else "recursive";
  inherit (hash_) outputHashAlgo outputHash;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;
} // (builtins.removeAttrs args customArgs))
