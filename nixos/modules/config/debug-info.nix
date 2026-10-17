{
  config,
  lib,
  pkgs,
  ...
}:
{

  options = {

    environment.enableDebugInfo = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Some NixOS packages provide debug symbols. However, these are
        not included in the system closure by default to save disk
        space. Enabling this option causes the debug symbols to appear
        in {file}`/run/current-system/sw/lib/debug/.build-id`,
        where tools such as {command}`gdb` can find them.
        If you need debug symbols for a package that doesn't
        provide them by default, you can enable them as follows:

            nixpkgs.config.packageOverrides = pkgs: {
              hello = pkgs.hello.overrideAttrs (oldAttrs: {
                separateDebugInfo = true;
              });
            };
      '';
    };

    environment.debuginfodServers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of urls of debuginfod servers for tools like {command}`gdb` and {command}`valgrind` to use.

        Unrelated to {option}`environment.enableDebugInfo`.
      '';
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.environment.enableDebugInfo {

      # FIXME: currently disabled because /lib is already in
      # environment.pathsToLink, and we can't have both.
      #environment.pathsToLink = [ "/lib/debug/.build-id" ];

      environment.extraOutputsToInstall = [ "debug" ];

      environment.variables.NIX_DEBUG_INFO_DIRS = [ "/run/current-system/sw/lib/debug" ];

    })
    (lib.mkIf (config.environment.debuginfodServers != [ ]) {
      environment.variables.DEBUGINFOD_URLS = lib.strings.concatStringsSep " " config.environment.debuginfodServers;

      environment.systemPackages = [
        # valgrind support requires debuginfod-find on PATH
        (lib.getBin pkgs.elfutils)
      ];

      environment.etc."gdb/gdbinit.d/nixseparatedebuginfod2.gdb".text = "set debuginfod enabled on";
    })
  ];

}
