{
  lib,
  callPackage,
  newScope,
  buildGo127Module,
  nix-update-script,
  nixosTests,
}:

let
  # Builder for plugins from https://github.com/openbao/openbao-plugins.
  mkOpenbaoPlugin = lib.extendMkDerivation {
    constructDrv = buildGo127Module;

    excludeDrvArgNames = [
      "plugin"
      "pluginType"
      "pluginName"
    ];

    extendDrvArgs =
      finalAttrs:
      {
        plugin,
        # Type and name of the `plugin "<type>" "<name>"` config stanza.
        pluginType,
        pluginName,
        ldflags ? [ ],
        postInstall ? "",
        passthru ? { },
        meta ? { },
        ...
      }:
      let
        path = lib.replaceStrings [ "-" ] [ "/" ] plugin;
      in
      {
        pname = "openbao-plugin-${plugin}";

        proxyVendor = true;

        subPackages = [ "${path}/cmd" ];

        ldflags = ldflags ++ [
          "-s"
          "-X github.com/openbao/openbao-plugins/${path}.pluginVersion=v${finalAttrs.version}"
        ];

        postInstall = postInstall + ''
          mv $out/bin/cmd $out/bin/${finalAttrs.pname}
        '';

        passthru = {
          inherit pluginType pluginName;

          tests = { inherit (nixosTests) openbao; };

          updateScript = nix-update-script {
            extraArgs = [
              "--use-github-releases"
              "--version-regex"
              "${plugin}-v(.*)"
            ];
          };
        }
        // passthru;

        meta = {
          homepage = "https://github.com/openbao/openbao-plugins";
          changelog = "https://github.com/openbao/openbao-plugins/releases/tag/${finalAttrs.src.tag}";
          license = lib.licenses.mpl20;
          mainProgram = finalAttrs.pname;
        }
        // meta;
      };
  };
in

lib.packagesFromDirectoryRecursive {
  inherit callPackage;
  newScope = scope: newScope ({ inherit mkOpenbaoPlugin; } // scope);
  directory = ./plugins;
}
