{ unwrapped, symlinkJoin, plugins ? [] }:

let
  unwrappedWithPlugins = symlinkJoin {
    name = unwrapped.name + "-oomox-root";
    paths = [ unwrapped ] ++ plugins;
  };
in

if builtins.length plugins == 0
then unwrapped
else unwrapped.overrideAttrs (old: {
  name = with old; "${pname}-${version}-with-plugins";

  buildInputs = old.buildInputs ++ plugins;

  preFixup = old.preFixup + ''
    gappsWrapperArgs+=(
        --set OOMOX_ROOT "${unwrappedWithPlugins}/opt/oomox"
        --prefix PATH : "$PATH"
    )
  '';
})
