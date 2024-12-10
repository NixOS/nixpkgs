{
  lib,
  fetchurl,
  stdenv,
  callPackages,
  runCommand,
}:

let
  inherit (builtins)
    match
    elemAt
    toJSON
    removeAttrs
    ;
  inherit (lib) importJSON mapAttrs;

  matchGitHubReference = match "github(.com)?:.+";
  getName = package: package.name or "unknown";
  getVersion = package: package.version or "0.0.0";

  # Fetch a module from package-lock.json -> packages
  fetchModule =
    {
      module,
      npmRoot ? null,
    }:
    (
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
                assert npmRoot != null;
                {
                  outPath = npmRoot + "/${module.resolved}";
                }
              )
            else if (scheme == "http" || scheme == "https") then
              (fetchurl {
                url = module.resolved;
                hash = module.integrity;
              })
            else if lib.hasPrefix "git" module.resolved then
              (builtins.fetchGit {
                url = module.resolved;
              })
            else
              throw "Unsupported URL scheme: ${scheme}"
          )
        )
      else
        null
    );

  # Manage node_modules outside of the store with hooks
  hooks = callPackages ./hooks { };

in
{
  importNpmLock =
    {
      npmRoot ? null,
      package ? importJSON (npmRoot + "/package.json"),
      packageLock ? importJSON (npmRoot + "/package-lock.json"),
      pname ? getName package,
      version ? getVersion package,
    }:
    let
      mapLockDependencies = mapAttrs (
        name: version:
        (
          # Substitute the constraint with the version of the dependency from the top-level of package-lock.
          if
            (
              # if the version is `latest`
              version == "latest"
              ||
                # Or if it's a github reference
                matchGitHubReference version != null
            )
          then
            packageLock'.packages.${"node_modules/${name}"}.version
          # But not a regular version constraint
          else
            version
        )
      );

      packageLock' = packageLock // {
        packages = mapAttrs (
          _: module:
          let
            src = fetchModule {
              inherit module npmRoot;
            };
          in
          (removeAttrs module [
            "link"
            "funding"
          ])
          // lib.optionalAttrs (src != null) {
            resolved = "file:${src}";
          }
          // lib.optionalAttrs (module ? dependencies) {
            dependencies = mapLockDependencies module.dependencies;
          }
          // lib.optionalAttrs (module ? optionalDependencies) {
            optionalDependencies = mapLockDependencies module.optionalDependencies;
          }
        ) packageLock.packages;
      };

      mapPackageDependencies = mapAttrs (
        name: _: packageLock'.packages.${"node_modules/${name}"}.resolved
      );

      # Substitute dependency references in package.json with Nix store paths
      packageJSON' =
        package
        // lib.optionalAttrs (package ? dependencies) {
          dependencies = mapPackageDependencies package.dependencies;
        }
        // lib.optionalAttrs (package ? devDependencies) {
          devDependencies = mapPackageDependencies package.devDependencies;
        };

      pname = package.name or "unknown";

    in
    runCommand "${pname}-${version}-sources"
      {
        inherit pname version;

        passAsFile = [
          "package"
          "packageLock"
        ];

        package = toJSON packageJSON';
        packageLock = toJSON packageLock';
      }
      ''
        mkdir $out
        cp "$packagePath" $out/package.json
        cp "$packageLockPath" $out/package-lock.json
      '';

  inherit hooks;
  inherit (hooks) npmConfigHook;

  __functor = self: self.importNpmLock;
}
