{ lib, makeWrapper, symlinkJoin, gnome, plugins }:

symlinkJoin {
  name = "evolution-with-plugins";
  paths = [ gnome.evolution-data-server ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for i in $out/bin/* $out/libexec/**; do
    if [ ! -d $i ]; then
      echo wrapping $i
      wrapProgram $i --set EDS_EXTRA_PREFIXES "${lib.concatStringsSep ":" plugins}"
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
