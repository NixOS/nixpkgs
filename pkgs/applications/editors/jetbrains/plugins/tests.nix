{
  jetbrains,
  symlinkJoin,
  lib,
  runCommand,
  # If not set, all IDEs are tested.
  ideName ? null,
}:

let

  # Known broken plugins, PLEASE remove entries here whenever possible.
  broken-plugins = [
  ];

  ides =
    if ideName == null then
      with jetbrains;
      [
        aqua
        clion
        datagrip
        dataspell
        gateway
        goland
        idea-community-src
        idea-community-bin
        idea-ultimate
        mps
        phpstorm
        pycharm-community-src
        pycharm-community-bin
        pycharm-professional
        rider
        ruby-mine
        rust-rover
        webstorm
        writerside
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
      paths = (map modify-ide ides);
    };

  # Test all plugins. This will only build plugins compatible with the IDE and version. It will fail if the plugin is marked
  # as compatible, but the build version is somehow not in the "builds" map (as that would indicate that something with update_plugins.py went wrong).
  all =
    let
      plugins-json = builtins.fromJSON (builtins.readFile ./plugins.json);
      plugins-for =
        with lib.asserts;
        ide:
        builtins.map (plugin: plugin.name) (
          builtins.filter (
            plugin:
            (
              # Plugin has to not be broken
              (!builtins.elem plugin.name broken-plugins)
              # IDE has to be compatible
              && (builtins.elem ide.pname plugin.compatible)
              # Assert: The build number needs to be included (if marked compatible)
              && (assertMsg (builtins.elem ide.buildNumber (builtins.attrNames plugin.builds)) "For plugin ${plugin.name} no entry for IDE build ${ide.buildNumber} is defined, even though ${ide.pname} is on that build.")
              # The plugin has to exist for the build
              && (plugin.builds.${ide.buildNumber} != null)
            )
          ) (builtins.attrValues plugins-json.plugins)
        );
      modify-ide = ide: jetbrains.plugins.addPlugins ide (plugins-for ide);
    in
    symlinkJoin {
      name = "jetbrains-test-plugins-all";
      paths = (map modify-ide ides);
    };

  # This test builds the IDEs with some plugins and checks that they can be discovered by the IDE.
  # Test always succeeds on IDEs that the tested plugins don't support.
  stored-correctly =
    let
      plugins-json = builtins.fromJSON (builtins.readFile ./plugins.json);
      plugin-ids = [
        # This is a "normal plugin", it's output must be linked into /${pname}/plugins.
        "8607" # nixidea
        # This is a plugin where the output contains a single JAR file. This JAR file needs to be linked directly in /${pname}/plugins.
        "7425" # wakatime
      ];
      check-if-supported =
        ide:
        builtins.all (
          plugin:
          (builtins.elem ide.pname plugins-json.plugins.${plugin}.compatible)
          && (plugins-json.plugins.${plugin}.builds.${ide.buildNumber} != null)
        ) plugin-ids;
      modify-ide = ide: jetbrains.plugins.addPlugins ide plugin-ids;
    in
    runCommand "test-jetbrains-plugins-stored-correctly"
      {
        idePaths = (map modify-ide (builtins.filter check-if-supported ides));
      }
      # TODO: instead of globbing using $ide/*/plugins we could probably somehow get the package name here properly.
      ''
        set -e
        exec &> >(tee -a "$out")

        IFS=' ' read -ra ideArray <<< "$idePaths"
        for ide in "''${ideArray[@]}"; do
          echo "processing $ide"

          echo "> ensure normal plugin is available"
          (
            set -x
            find -L $ide/*/plugins -type f -iname 'NixIDEA-*.jar' | grep .
          )

          echo "> ensure single JAR file plugin is available"
          (
            set -x
            PATH_TO_LINK=$(find $ide/*/plugins -maxdepth 1 -type l -iname '*wakatime.jar' | grep .)
            test -f $(readlink $PATH_TO_LINK)
          )
          echo ""
        done

        echo "test done! ok!"
      '';
}
