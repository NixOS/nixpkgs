{
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  nushell,
  plugins ? [ ],
}:
/*
  `plugins`
   :  A list of nushell plugins to install alongside nushell. Here's an example:

      ~~~
      pkgs.nushell.withPlugins [
        nushellPlugins.formats
        nushellPlugins.query
        nushellPlugins.polars
      ]
      ~~~

    Plugins get placed in lib/nushell/plugins and get loaded via the
    --plugins CLI flag. They'll work in both interactive and non-interactive
    shells, but the downside is if you want to change or disable plugins,
    you'll have to rebuild.

    So: use `nushell.withPlugins` for devShells and non-interactive shells
    where you can't modify the plugin registry first (e.g. if there's no
    writeable home directory). Use nixos' `programs.nushell.plugins` for
    interactive shells.
*/
symlinkJoin {
  inherit (nushell) version;
  pname = "${nushell.pname}-with-plugins";

  paths = [ nushell ] ++ plugins;

  nativeBuildInputs = [ makeBinaryWrapper ];
  postBuild = ''
    # Move plugin binaries from bin/ to lib/nushell/plugins/ so they
    # don't pollute PATH.
    mkdir -p $out/lib/nushell/plugins

    # `nu --plugins` is not variadic despite the docs; each plugin needs its
    # own `--plugins` flag. See https://www.nushell.sh/book/plugins.html
    pluginFlags=""
    ${lib.concatMapStringsSep "\n" (
      p:
      let
        pluginName = baseNameOf (lib.getExe p);
      in
      ''
        mv "$out/bin/${pluginName}" "$out/lib/nushell/plugins/${pluginName}"
        pluginFlags="$pluginFlags --plugins $out/lib/nushell/plugins/${pluginName}"
      ''
    ) plugins}

    wrapProgram $out/bin/nu --add-flags "$pluginFlags"
  '';

  meta = removeAttrs nushell.meta [
    "name"
    "outputsToInstall"
    "position"
  ];
}
