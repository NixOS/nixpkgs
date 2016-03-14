{ config, lib, ... }:

with lib;

{

  options = {

    environment.enableDebugInfo = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Some NixOS packages provide debug symbols. However, these are
        not included in the system closure by default to save disk
        space. Enabling this option causes the debug symbols to appear
        in <filename>/run/current-system/sw/lib/debug/.build-id</filename>,
        where tools such as <command>gdb</command> can find them.
        If you need debug symbols for a package that doesn't
        provide them by default, you can enable them as follows:
        <!-- FIXME: ugly, see #10721 -->
        <programlisting>
        nixpkgs.config.packageOverrides = pkgs: {
          hello = overrideDerivation pkgs.hello (attrs: {
            outputs = attrs.outputs or ["out"] ++ ["debug"];
            buildInputs = attrs.buildInputs ++ [&lt;nixpkgs/pkgs/build-support/setup-hooks/separate-debug-info.sh>];
          });
        };
        </programlisting>
      '';
    };

  };


  config = {

    # FIXME: currently disabled because /lib is already in
    # environment.pathsToLink, and we can't have both.
    #environment.pathsToLink = [ "/lib/debug/.build-id" ];

    environment.extraOutputsToInstall =
      optional config.environment.enableDebugInfo "debug";

  };

}
