{ lib, runCommand, writeScriptBin, buildEnv
, python3Packages, perlPackages, runtimeShell
}:

weechat:

let
  wrapper = {
    installManPages ? true
  , configure ? { availablePlugins, ... }: { plugins = builtins.attrValues availablePlugins; }
  }:

  let
    perlInterpreter = perlPackages.perl;
    availablePlugins = let
        simplePlugin = name: {pluginFile = "${weechat.${name}}/lib/weechat/plugins/${name}.so";};
      in rec {
        python = (simplePlugin "python") // {
          extraEnv = ''
            export PATH="${python3Packages.python}/bin:$PATH"
          '';
          withPackages = pkgsFun: (python // {
            extraEnv = ''
              export PYTHONHOME="${python3Packages.python.withPackages pkgsFun}"
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

      mkScript = drv: lib.forEach drv.scripts (script: "/script load ${drv}/share/${script}");

      scripts = builtins.concatStringsSep ";" (lib.foldl (scripts: drv: scripts ++ mkScript drv)
        [ ] (config.scripts or []));
    in "${scripts};${init}";

    mkWeechat = bin: (writeScriptBin bin ''
      #!${runtimeShell}
      export WEECHAT_EXTRA_LIBDIR=${pluginsDir}
      ${lib.concatMapStringsSep "\n" (p: lib.optionalString (p ? extraEnv) p.extraEnv) plugins}
      exec ${weechat}/bin/${bin} "$@" --run-command ${lib.escapeShellArg init}
    '') // {
      inherit (weechat) name man;
      unwrapped = weechat;
      outputs = [ "out" "man" ];
    };
  in buildEnv {
    name = "weechat-bin-env-${weechat.version}";
    extraOutputsToInstall = lib.optionals installManPages [ "man" ];
    paths = [
      (mkWeechat "weechat")
      (mkWeechat "weechat-headless")
      (runCommand "weechat-out-except-bin" { } ''
        mkdir $out
        ln -sf ${weechat}/include $out/include
        ln -sf ${weechat}/lib $out/lib
        ln -sf ${weechat}/share $out/share
      '')
    ];
    meta = builtins.removeAttrs weechat.meta [ "outputsToInstall" ];
  };

in lib.makeOverridable wrapper
