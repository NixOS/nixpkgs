{ lib, stdenvNoCC, cacert, git, nodePackages, jq, moreutils }:

{ packageJson
, yarnLock ? null
, packageLockJson ? null
, nodeModulesSha256
, name ? "node_modules"
, version 
, yarnFlags ? [ "--frozen-lockfile" "--production=false" "--verbose" "--check-files" ]
, patches ? []
, ...
} @ args:

assert (packageLockJson != null) -> (yarnLock == null); 
assert (yarnLock != null) -> (packageLockJson == null); 
  
stdenvNoCC.mkDerivation ({
  name = "${name}-${version}.tar.gz";
  nativeBuildInputs = [ cacert git nodePackages.yarn ];
  
  dontUnpack = true;

  configurePhase = ''
    runHook preConfigure

    # Yarn writes cache directories etc to $HOME.
    export HOME=$(mktemp -d yarn-home.XXX)

    cp ${packageJson} ./package.json
    
    ${lib.optionalString (packageLockJson != null) ''
      cp ${packageLockJson} ./package-lock.json
    ''}

    ${lib.optionalString (yarnLock != null) ''
      cp ${yarnLock} ./yarn.lock
    ''}
    
    packageJsonVersion=$(${jq}/bin/jq '.version' package.json)
    
    if [[ $packageJsonVersion == null ]]; then
        echo "Warning: missing version in package.json"
        echo "yarn will not work properly without a version attribute, patching..."
        ${jq}/bin/jq '.version = "${version}"' package.json | ${moreutils}/bin/sponge package.json
    fi

    yarn config set yarn-offline-mirror $name
    yarn config set disable-self-update-check true
    
    runHook postConfigure
  '';
  
  buildPhase = ''
    runHook preBuild

    ${lib.optionalString (packageLockJson != null) ''
      yarn import
      # just to remove the warning from yarn if you have both a yarn.lock and package-lock.json files
      rm package-lock.json
    ''}
    
    yarn install ${lib.concatStringsSep " " yarnFlags}

    cp -r node_modules $name
    
    ${lib.optionalString (packageLockJson != null) ''
      # Add the yarn.lock to allow hash invalidation
      cp yarn.lock $name/yarn.lock
    ''}
    
    runHook postBuild
  '';

  SOURCE_DATE_EPOCH=1;
  # Build a reproducible tar, per instructions at https://reproducible-builds.org/docs/archives/  
  installPhase = ''
    tar --owner=0 --group=0 --numeric-owner --format=gnu \
        --sort=name --mtime="@$SOURCE_DATE_EPOCH" \
        -czf $out $name
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = nodeModulesSha256;  
  
  impureEnvVars = lib.fetchers.proxyImpureEnvVars;
} // (builtins.removeAttrs args [
  "name" "nodeModulesSha256" "importPackageLockJson" "yarnFlags"
]))
