# Shamelessly stolen and modified from mpv/wrapper.nix
# Arguments that this derivation gets when it is created with `callPackage`
{ stdenv
, lib
, makeWrapper
, symlinkJoin
}:

# the unwrapped CraftOS-PC derivation - 1st argument to `wrapCraftos`
craftos-pc:

let
  # arguments to the function (exposed as `wrapMpv` in all-packages.nix)
  wrapper = {
    extraMakeWrapperArgs ? [],
    # a set of derivations (probably from `craftosPlugins`) where each is
    # expected to have a `pluginName` passthru attribute that points to the
    # name of the script that would reside in the script's derivation's
    # `$out/share/craftos/plugins/`.
    plugins ? [],
  }:
  let
    # All arguments besides the input and output binaries (${craftos-pc}/bin/craftos and
    # $out/bin/craftos). These are used by the darwin specific makeWrapper call
    # used to wrap $out/Applications/CraftOS-PC.app/Contents/MacOS/craftos as well.
    mostMakeWrapperArgs = lib.strings.escapeShellArgs ([ "--inherit-argv0"
    ] ++ (lib.lists.flatten (map
      # For every script in the `scripts` argument, add the necessary flags to the wrapper
      (plugin:
        [
          # Here we rely on the existence of the `pluginName` passthru
          # attribute of the script derivation from the `scripts`
          "--plugin ${plugin}/share/craftos/plugins/${plugin.pluginName}${stdenv.hostPlatform.extensions.sharedLibrary}"
        ]
      ) plugins
    )) ++ extraMakeWrapperArgs)
    ;
  in
    symlinkJoin {
      name = "craftos-pc-with-plugins-${craftos-pc.version}";

      paths = craftos-pc.all;

      nativeBuildInputs = [ makeWrapper ];

      passthru.unwrapped = craftos-pc;

      postBuild = ''
        # wrapProgram can't operate on symlinks
        rm "$out/bin/${craftos-pc.meta.mainProgram}"
        makeWrapper "${craftos-pc}/bin/${craftos-pc.meta.mainProgram}" "$out/bin/${craftos-pc.meta.mainProgram}" ${mostMakeWrapperArgs}
      '' + lib.optionalString stdenv.isDarwin ''
        # wrapProgram can't operate on symlinks
        rm "$out/Applications/CraftOS-PC.app/Contents/MacOS/craftos"
        makeWrapper "${craftos-pc}/Applications/CraftOS-PC.app/Contents/MacOS/craftos" "$out/Applications/CraftOS-PC.app/Contents/MacOS/${craftos-pc.meta.mainProgram}" ${mostMakeWrapperArgs}
      '';

      meta = {
        inherit (craftos-pc.meta) mainProgram homepage description maintainers;
      };
    };
in
  lib.makeOverridable wrapper
