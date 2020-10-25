{ lib, makeWrapper, symlinkJoin, gnome3, plugins }:

symlinkJoin {
  name = "evolution-with-plugins";
  paths = [ gnome3.evolution-data-server ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    for i in $out/bin/* $out/libexec/**; do
    if [ ! -d $i ]; then
      echo wrapping $i
      wrapProgram $i \
        --set LD_LIBRARY_PATH "$out/lib" \
        --set EDS_ADDRESS_BOOK_MODULES "$out/lib/evolution-data-server/addressbook-backends/" \
        --set EDS_CALENDAR_MODULES "$out/lib/evolution-data-server/calendar-backends/" \
        --set EDS_CAMEL_PROVIDER_DIR "$out/lib/evolution-data-server/camel-providers/" \
        --set EDS_REGISTRY_MODULES "$out/lib/evolution-data-server/registry-modules/" \
        --set EVOLUTION_MODULEDIR "$out/lib/evolution/modules"
    fi
    done

    fixSymlink () {
     local link=$1
     local target=$(readlink $link);
     local newtarget=$(sed "s@/nix/store/[^/]*/@$out/@" <<< "$target")
     if [[ $target != $newtarget ]] && [[ -d $newtarget ]]; then
       echo fixing link to point to $newtarget instead of $target
       rm $link
       ln -s $newtarget $link
     fi
    }

    fixSymlink $out/share/dbus-1/service
    fixSymlink $out/lib/systemd/user
    for i in $out/share/dbus-1/services/*.service $out/lib/systemd/user/*.service; do
      echo fixing service file $i to point to $out
      sed -i "s@/nix/store/[^/]*/@$out/@" $i
    done
  '';
}
