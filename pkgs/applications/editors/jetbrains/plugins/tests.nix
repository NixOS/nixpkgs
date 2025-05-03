{
  jetbrains,
  symlinkJoin,
  lib,
  # If not set, all IDEs are tested.
  ideName ? null,
}:

let

  # Known broken plugins, PLEASE remove entries here whenever possible.
  brokenPlugins = [
    "github-copilot" # GitHub Copilot: https://github.com/NixOS/nixpkgs/issues/400317
  ];

  ideNames =
    if ideName == null then
      with jetbrains;
      [
        clion
        datagrip
        dataspell
        goland
        idea-community
        idea-ultimate
        mps
        phpstorm
        pycharm-community
        pycharm-professional
        rider
        ruby-mine
        rust-rover
        webstorm
      ]
    else
      [ (jetbrains.${ideName}) ];
in
{
  # Check to see if the process for adding plugins is breaking anything, instead of the plugins themselves
  empty =
    let
      modify-ide = ide: jetbrains.plugins.addPlugins ide [ ];
    in
    symlinkJoin {
      name = "jetbrains-test-plugins-empty";
      paths = (map modify-ide ideNames);
    };

  # Test all plugins. This will only build plugins compatible with the IDE and version. It will fail if the plugin is marked
  # as compatible, but the build version is somehow not in the "builds" map (as that would indicate that something with update_plugins.py went wrong).
  all =
    let
      pluginsJson = builtins.fromJSON (builtins.readFile ./plugins.json);
      pluginsFor =
        with lib.asserts;
        ide:
        builtins.map (plugin: plugin.name) (
          builtins.filter (
            plugin:
            (
              # Plugin has to not be broken
              (!builtins.elem plugin.name brokenPlugins)
              # IDE has to be compatible
              && (builtins.elem ide.pname plugin.compatible)
              # Assert: The build number needs to be included (if marked compatible)
              && (assertMsg (builtins.elem ide.buildNumber (builtins.attrNames plugin.builds)) "For plugin ${plugin.name} no entry for IDE build ${ide.buildNumber} is defined, even though ${ide.pname} is on that build.")
              # The plugin has to exist for the build
              && (plugin.builds.${ide.buildNumber} != null)
            )
          ) (builtins.attrValues pluginsJson.plugins)
        );
      modify-ide = ide: jetbrains.plugins.addPlugins ide (pluginsFor ide);
    in
    symlinkJoin {
      name = "jetbrains-test-plugins-all";
      paths = (map modify-ide ideNames);
    };
}
