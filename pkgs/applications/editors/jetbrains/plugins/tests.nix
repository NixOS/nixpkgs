{
  jetbrains,
  symlinkJoin,
  lib,
  runCommand,
  fetchzip,
  fetchurl,
  # If not set, all IDEs are tested.
  ideName ? null,
}:

let
  ides =
    if ideName == null then
      with jetbrains;
      [
        clion
        datagrip
        dataspell
        gateway
        goland
        idea-oss
        idea
        mps
        phpstorm
        pycharm-oss
        pycharm
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
      paths = (map modify-ide ides);
    };

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
