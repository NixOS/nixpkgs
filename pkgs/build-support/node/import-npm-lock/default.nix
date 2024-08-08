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
                fetchurl {
                  url = module.resolved;
                  hash = module.integrity;
                }
              )
            else if lib.hasPrefix "git" module.resolved then
              (
                builtins.fetchGit {
                  url = module.resolved;
                }
              )
            else throw "Unsupported URL scheme: ${scheme}"
          )
        )
      else null
    );

  cleanModule = lib.flip removeAttrs [ "link" "funding" ];

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
            (_: module:
              let
                src = fetchModule {
                  inherit module npmRoot;
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
    let
      cleanAttrs = lib.flip removeAttrs [ "npmRoot" "package" "packageLock" "nodejs" ];
    in
    { npmRoot ? null
    , package ? importJSON (npmRoot + "/package.json")
    , packageLock ? importJSON (npmRoot + "/package-lock.json")
    , nodejs
    , ...
    }@attrs:
    stdenv.mkDerivation (cleanAttrs attrs // {
      pname = attrs.pname or "${getName package}-node-modules";
      version = attrs.version or getVersion package;

      dontUnpack = true;

      npmDeps = self.importNpmLock {
        inherit npmRoot package packageLock;
      };

      nativeBuildInputs = [
        nodejs
        nodejs.passthru.python
        hooks.npmConfigHook
      ];

      package = toJSON package;
      packageLock = toJSON packageLock;
      passAsFile = [ "package" "packageLock" ];

      postPatch = ''
        cp --no-preserve=mode "$packagePath" package.json
        cp --no-preserve=mode "$packageLockPath" package-lock.json
      '';

      installPhase = ''
        runHook preInstall
        mkdir $out
        cp package.json $out/
        cp package-lock.json $out/
        [[ -d node_modules ]] && mv node_modules $out/
        runHook postInstall
      '';
    });

  inherit hooks;
  inherit (hooks) npmConfigHook linkNodeModulesHook;

  __functor = self: self.importNpmLock;
})
