{ lib, makeWrapper, symlinkJoin, evolution, evolution-ews, gnome3 }:

symlinkJoin {
  name = "evolution-with-plugins";
  paths = [ evolution evolution-ews gnome3.evolution-data-server];

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

    LIBRARIES=$(ls -d ${lib.makeLibraryPath [evolution-ews]}/*)
    for library in $LIBRARIES; do
      for plugin in $(ls $library); do
        echo $library
        echo "\n"
        echo $plugin
        ln -sf $library/$plugin $out/lib/$plugin
      done
    done

    for i in $out/share/dbus-1/services/*.service $out/lib/systemd/user/*.service; do
      echo fixing service file $i
      sed -i "s@/nix/store/[^/]*/@$out/@" $i
    done
  '';
}
