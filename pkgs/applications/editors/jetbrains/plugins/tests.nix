{
  jetbrains,
  symlinkJoin,
  lib,
  runCommand,
<<<<<<< HEAD
  fetchzip,
  fetchurl,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # If not set, all IDEs are tested.
  ideName ? null,
}:

let
<<<<<<< HEAD
=======

  # Known broken plugins, PLEASE remove entries here whenever possible.
  broken-plugins = [
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
        idea-oss
        idea
=======
        idea-ultimate
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        mps
        phpstorm
        pycharm-community-src
        pycharm-community-bin
<<<<<<< HEAD
        pycharm-oss
        pycharm
=======
        pycharm-professional
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  # This test builds the IDEs with some plugins and checks that they can be discovered by the IDE.
  # We ignore IDE compatibility here so we don't have to maintain the plugin versions used below,
  # the only thing we care about is that they are properly placed.
  stored-correctly =
    let
      # This is a "normal plugin", it's output must be linked into /${pname}/plugins.
      nixidea = fetchzip {
        url = "https://plugins.jetbrains.com/files/8607/786671/NixIDEA-0.4.0.18.zip";
        hash = "sha256-JShheBoOBiWM9HubMUJvBn4H3DnWykvqPyrmetaCZiM=";
      };

      # This is a plugin where the output contains a single JAR file. This JAR file needs to be linked directly in /${pname}/plugins.
      wakatime = fetchurl {
        executable = true;
        url = "https://plugins.jetbrains.com/files/7425/760442/WakaTime.jar";
        hash = "sha256-DobKZKokueqq0z75d2Fo3BD8mWX9+LpGdT9C7Eu2fHc=";
      };

      modify-ide =
        ide:
        jetbrains.plugins.addPlugins ide [
          nixidea
          wakatime
        ];
    in
    runCommand "test-jetbrains-plugins-stored-correctly"
      {
        idePaths = (map modify-ide ides);
=======
  # Test all plugins. This will only build plugins compatible with the IDE and version. It will fail if the plugin is marked
  # as compatible, but the build version is somehow not in the "builds" map (as that would indicate that something with update_plugins.py went wrong).
  all =
    let
      plugins-json = builtins.fromJSON (builtins.readFile ./plugins.json);
      plugins-for =
        with lib.asserts;
        ide:
        map (plugin: plugin.name) (
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
