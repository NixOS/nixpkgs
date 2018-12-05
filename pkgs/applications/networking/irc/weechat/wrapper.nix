{ pythonPackages, perl, runCommand, lib, writeScriptBin, stdenv
}:

weechat:

let
  wrapper = {
    configure ? { availablePlugins, ... }: { plugins = builtins.attrValues availablePlugins; }
  }:

  let
    perlInterpreter = perl;
    config = configure {
      availablePlugins = let
        simplePlugin = name: { pluginFile = "${weechat.${name}}/lib/weechat/plugins/${name}.so"; };
        in rec {
          python = {
            pluginFile = "${weechat.python}/lib/weechat/plugins/python.so";
            withPackages = pkgsFun: (python // {
              extraEnv = ''
                export PYTHONHOME="${pythonPackages.python.withPackages pkgsFun}"
              '';
            });
          };
          perl = (simplePlugin "perl") // {
            extraEnv = ''
              export PATH="${perlInterpreter}/bin:$PATH"
            '';
          };
          tcl = simplePlugin "tcl";
          ruby = simplePlugin "ruby";
          guile = simplePlugin "guile";
          lua = simplePlugin "lua";
        };
    };

    inherit (config) plugins;

    pluginsDir = runCommand "weechat-plugins" {} ''
      mkdir -p $out/plugins
      for plugin in ${lib.concatMapStringsSep " " (p: p.pluginFile) plugins} ; do
        ln -s $plugin $out/plugins
      done
    '';

  in (writeScriptBin "weechat" ''
    #!${stdenv.shell}
    export WEECHAT_EXTRA_LIBDIR=${pluginsDir}
    ${lib.concatMapStringsSep "\n" (p: lib.optionalString (p ? extraEnv) p.extraEnv) plugins}
    exec ${weechat}/bin/weechat "$@"
  '') // {
    name = weechat.name;
    unwrapped = weechat;
    meta = weechat.meta;
  };

in lib.makeOverridable wrapper
