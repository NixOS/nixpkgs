{ lib
, fetchurl
, stdenv
, callPackages
, runCommand
}:

let
  inherit (builtins) match elemAt toJSON removeAttrs;
  inherit (lib) importJSON mapAttrs;

  matchGitHubReference = match "github(.com)?:.+";
  getName = package: package.name or "unknown";
  getVersion = package: package.version or "0.0.0";

  # Fetch a module from package-lock.json -> packages
  fetchModule =
    { module
    , npmRoot ? null
    , fetcherOpts
    }: (
      if module ? "resolved" then
        (
          let
            # Parse scheme from URL
            mUrl = match "(.+)://(.+)" module.resolved;
            scheme = elemAt mUrl 0;
          in
          (
            if mUrl == null then
              (
                assert npmRoot != null; {
                  outPath = npmRoot + "/${module.resolved}";
                }
              )
            else if (scheme == "http" || scheme == "https") then
              (
                fetchurl ({
                  url = module.resolved;
                  hash = module.integrity;
                } // fetcherOpts )
              )
            else if lib.hasPrefix "git" module.resolved then
              (
                builtins.fetchGit ({
                  url = module.resolved;
                }  // fetcherOpts )
              )
            else throw "Unsupported URL scheme: ${scheme}"
          )
        )
      else null
    );

  cleanModule = lib.flip removeAttrs [
    "link" # Remove link not to symlink directories. These have been processed to store paths already.
    "funding" # Remove funding to get rid sponsorship nag in build output
  ];

  # Manage node_modules outside of the store with hooks
  hooks = callPackages ./hooks { };

in
lib.fix (self: {
  importNpmLock =
    { npmRoot ? null
    , package ? importJSON (npmRoot + "/package.json")
    , packageLock ? importJSON (npmRoot + "/package-lock.json")
    , pname ? getName package
    , version ? getVersion package
    # A map of additional fetcher options forwarded to the fetcher used to download the package.
    # Example: { "node_modules/axios" = { curlOptsList = [ "--verbose" ]; }; }
    # This will download the axios package with curl's verbose option.
    , fetcherOpts ?  {}
    }:
    let
      mapLockDependencies =
        mapAttrs
          (name: version: (
            # Substitute the constraint with the version of the dependency from the top-level of package-lock.
            if (
              # if the version is `latest`
              version == "latest"
              ||
              # Or if it's a github reference
              matchGitHubReference version != null
            ) then packageLock'.packages.${"node_modules/${name}"}.version
            # But not a regular version constraint
            else version
          ));

      packageLock' = packageLock // {
        packages =
          mapAttrs
            (modulePath: module:
              let
                src = fetchModule {
                  inherit module npmRoot;
                  fetcherOpts = fetcherOpts.${modulePath} or {};
                };
              in
              cleanModule module
              // lib.optionalAttrs (src != null) {
                resolved = "file:${src}";
              } // lib.optionalAttrs (module ? dependencies) {
                dependencies = mapLockDependencies module.dependencies;
              } // lib.optionalAttrs (module ? optionalDependencies) {
                optionalDependencies = mapLockDependencies module.optionalDependencies;
              })
            packageLock.packages;
      };

      mapPackageDependencies = mapAttrs (name: _: packageLock'.packages.${"node_modules/${name}"}.resolved);

      # Substitute dependency references in package.json with Nix store paths
      packageJSON' = package // lib.optionalAttrs (package ? dependencies) {
        dependencies = mapPackageDependencies package.dependencies;
      } // lib.optionalAttrs (package ? devDependencies) {
        devDependencies = mapPackageDependencies package.devDependencies;
      };

      pname = package.name or "unknown";

    in
    runCommand "${pname}-${version}-sources"
      {
        inherit pname version;

        passAsFile = [ "package" "packageLock" ];

        package = toJSON packageJSON';
        packageLock = toJSON packageLock';
      } ''
      mkdir $out
      cp "$packagePath" $out/package.json
      cp "$packageLockPath" $out/package-lock.json
    '';

  # Build node modules from package.json & package-lock.json
  buildNodeModules =
    { npmRoot ? null
    , package ? importJSON (npmRoot + "/package.json")
    , packageLock ? importJSON (npmRoot + "/package-lock.json")
    , nodejs
    , derivationArgs ? { }
    }:
    stdenv.mkDerivation ({
      pname = derivationArgs.pname or "${getName package}-node-modules";
      version = derivationArgs.version or getVersion package;

      dontUnpack = true;

      npmDeps = self.importNpmLock {
        inherit npmRoot package packageLock;
      };

      package = toJSON package;
      packageLock = toJSON packageLock;

      installPhase = ''
        runHook preInstall
        mkdir $out
        cp package.json $out/
        cp package-lock.json $out/
        [[ -d node_modules ]] && mv node_modules $out/
        runHook postInstall
      '';
    } // derivationArgs // {
      nativeBuildInputs = [
        nodejs
        nodejs.passthru.python
        hooks.npmConfigHook
      ] ++ derivationArgs.nativeBuildInputs or [ ];

      passAsFile = [ "package" "packageLock" ] ++ derivationArgs.passAsFile or [ ];

      postPatch = ''
        cp --no-preserve=mode "$packagePath" package.json
        cp --no-preserve=mode "$packageLockPath" package-lock.json
      '' + derivationArgs.postPatch or "";
    });

  inherit hooks;
  inherit (hooks) npmConfigHook linkNodeModulesHook;

  __functor = self: self.importNpmLock;
})
