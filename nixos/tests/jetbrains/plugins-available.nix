{ pkgs, ... }:

# This test builds IDEA Community with some plugins and checks that they can be discovered by the IDE.
let
  idea = (
    pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-community-src [
      # This is a "normal plugin", it's output must be linked into /idea-community/plugins.
      "ideavim"
      # This is a plugin where the output contains a single JAR file. This JAR file needs to be linked directly in /idea-community/plugins.
      "wakatime"
    ]
  );
in
{
  name = "jetbrains_build-ide-with-plugins";
  meta.maintainers = pkgs.lib.teams.jetbrains.members;

  nodes = {
    server =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [
          idea
        ];
      };
  };

  testScript =
    { ... }:
    ''
      with subtest("ensure normal plugin is available"):
          machine.succeed("find -L ${idea.out}/idea-community/plugins -type f -iname 'IdeaVIM-*.jar' | grep .")

      with subtest("ensure single JAR file plugin is available"):
          machine.succeed("""
      PATH_TO_LINK=$(find ${idea.out}/idea-community/plugins -maxdepth 1 -type l -iname '*wakatime.jar' | grep .)
      test -f $(readlink $PATH_TO_LINK)
          """)
    '';

}
