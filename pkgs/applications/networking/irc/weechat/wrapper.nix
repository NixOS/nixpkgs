{ stdenv, lib, runCommand, writeScriptBin, buildEnv
, pythonPackages, perlPackages
}:

weechat:

let
  wrapper = {
    configure ? { availablePlugins, ... }: { plugins = builtins.attrValues availablePlugins; }
  }:

  let
    perlInterpreter = perlPackages.perl;
    availablePlugins = let
        simplePlugin = name: {pluginFile = "${weechat.${name}}/lib/weechat/plugins/${name}.so";};
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
          withPackages = pkgsFun: (perl // {
            extraEnv = ''
              ${perl.extraEnv}
              export PERL5LIB=${perlPackages.makeFullPerlPath (pkgsFun perlPackages)}
            '';
          });
        };
        tcl = simplePlugin "tcl";
        ruby = simplePlugin "ruby";
        guile = simplePlugin "guile";
        lua = simplePlugin "lua";
      };

    config = configure { inherit availablePlugins; };

    plugins = config.plugins or (builtins.attrValues availablePlugins);

    pluginsDir = runCommand "weechat-plugins" {} ''
      mkdir -p $out/plugins
      for plugin in ${lib.concatMapStringsSep " " (p: p.pluginFile) plugins} ; do
        ln -s $plugin $out/plugins
      done
    '';

    init = let
      init = builtins.replaceStrings [ "\n" ] [ ";" ] (config.init or "");

      mkScript = drv: lib.flip map drv.scripts (script: "/script load ${drv}/share/${script}");

      scripts = builtins.concatStringsSep ";" (lib.foldl (scripts: drv: scripts ++ mkScript drv)
        [ ] (config.scripts or []));
    in "${scripts};${init}";

    mkWeechat = bin: (writeScriptBin bin ''
      #!${stdenv.shell}
      export WEECHAT_EXTRA_LIBDIR=${pluginsDir}
      ${lib.concatMapStringsSep "\n" (p: lib.optionalString (p ? extraEnv) p.extraEnv) plugins}
      exec ${weechat}/bin/${bin} "$@" --run-command ${lib.escapeShellArg init}
    '') // {
      inherit (weechat) name;
      unwrapped = weechat;
    };
  in buildEnv {
    name = "weechat-bin-env-${weechat.version}";
    paths = [
      (mkWeechat "weechat")
      (mkWeechat "weechat-headless")
    ];
    meta = builtins.removeAttrs weechat.meta [ "outputsToInstall" ];
  };

in lib.makeOverridable wrapper
