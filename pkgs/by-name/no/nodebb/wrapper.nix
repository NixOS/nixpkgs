{
  lib,
  runCommand,
  makeBinaryWrapper,
  nodebb,
}:

f:
let
  extraPlugins = f nodebb.plugins;
  pluginDir = plugin: plugin.pluginName or plugin.pname;
  pluginLink =
    plugin:
    let
      name = pluginDir plugin;
      nested = "${plugin}/lib/node_modules/${name}";
    in
    ''
      if [ ! -d ${lib.escapeShellArg nested} ]; then
        echo "nodebb plugin ${name} must install to ${nested}" >&2
        exit 1
      fi
      ln -sfn ${lib.escapeShellArg nested} "$out/lib/node_modules/nodebb/node_modules/${name}"
    '';
in
runCommand "${nodebb.pname}-with-packages-${nodebb.version}"
  {
    nativeBuildInputs = [ makeBinaryWrapper ];
    inherit (nodebb) meta;
    passthru = nodebb.passthru // {
      inherit extraPlugins;
      extraPluginIds = map pluginDir extraPlugins;
      withPackages = g: nodebb.withPackages (ps: extraPlugins ++ g ps);
    };
  }
  ''
    mkdir -p $out/lib/node_modules $out/bin
    cp -a ${nodebb}/lib/node_modules/nodebb $out/lib/node_modules/nodebb
    chmod -R u+w $out/lib/node_modules/nodebb
    ${lib.concatMapStrings pluginLink extraPlugins}

    makeBinaryWrapper ${lib.getExe nodebb.nodejs} $out/bin/nodebb \
      --add-flags $out/lib/node_modules/nodebb/nodebb \
      --set-default NODE_ENV production \
      --chdir $out/lib/node_modules/nodebb
  ''
