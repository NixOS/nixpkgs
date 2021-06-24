{ symlinkJoin, makeWrapper, kakoune, plugins ? [], configure ? {} }:

let
  # "plugins" is the preferred way, but some configurations may be
  # using "configure.plugins", so accept both
  requestedPlugins = plugins ++ (configure.plugins or []);

in
  symlinkJoin {
    name = "kakoune-${kakoune.version}";

    nativeBuildInputs = [ makeWrapper ];

    paths = [ kakoune ] ++ requestedPlugins;

    postBuild = ''
      # location of kak binary is used to find ../share/kak/autoload,
      # unless explicitly overriden with KAKOUNE_RUNTIME
      rm "$out/bin/kak"
      makeWrapper "${kakoune}/bin/kak" "$out/bin/kak" --set KAKOUNE_RUNTIME "$out/share/kak"

      # currently kakoune ignores doc files if they are symlinks, so workaround by
      # copying doc files over, so they become regular files...
      mkdir "$out/DELETE_ME"
      mv "$out/share/kak/doc" "$out/DELETE_ME"
      cp -r --dereference "$out/DELETE_ME/doc" "$out/share/kak"
      rm -Rf "$out/DELETE_ME"
    '';

    meta = kakoune.meta // { priority = (kakoune.meta.priority or 0) - 1; };
  }
