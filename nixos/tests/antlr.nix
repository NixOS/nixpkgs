{ lib, ... }:
{
  name = "antlr";

  containers.container =
    { pkgs, ... }:
    {
      programs.java = {
        enable = true;
        package = pkgs.jdk11_headless;
      };
      environment.systemPackages = [ pkgs.antlr ];
    };

  testScript = ''
    container.succeed('if [ -z "$JAVA_HOME" ]; then exit 1; fi')
    container.succeed("antlr")
  '';
}
