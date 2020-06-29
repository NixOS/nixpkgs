{ symlinkJoin, makeWrapper, kakoune, plugins ? [], configure ? {} }:

let
  # "plugins" is the preferred way, but some configurations may be
  # using "configure.plugins", so accept both
  requestedPlugins = plugins ++ (configure.plugins or []);

in
  symlinkJoin {
    name = "kakoune-${kakoune.version}";

    buildInputs = [ makeWrapper ];

    paths = [ kakoune ] ++ requestedPlugins;

    postBuild = ''
      # location of kak binary is used to find ../share/kak/autoload,
      # unless explicitly overriden with KAKOUNE_RUNTIME
      rm "$out/bin/kak"
      makeWrapper "${kakoune}/bin/kak" "$out/bin/kak" --set KAKOUNE_RUNTIME "$out/share/kak"
    '';

    meta = kakoune.meta // { priority = (kakoune.meta.priority or 0) - 1; };
  }
