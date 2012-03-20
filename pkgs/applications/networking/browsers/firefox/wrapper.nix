{ stdenv, browser, makeDesktopItem, makeWrapper, plugins, libs
, browserName, desktopName, nameSuffix, icon
}:

stdenv.mkDerivation {
  name = browser.name + "-with-plugins";

  desktopItem = makeDesktopItem {
    name = browserName;
    exec = browserName + " %U";
    icon = icon;
    comment = "";
    desktopName = desktopName;
    genericName = "Web Browser";
    categories = "Application;Network;WebBrowser;";
  };

  buildInputs = [makeWrapper];

  buildCommand = ''
    if [ ! -x "${browser}/bin/${browserName}" ]
    then
        echo "cannot find executable file \`${browser}/bin/${browserName}'"
        exit 1
    fi

    makeWrapper "${browser}/bin/${browserName}" \
        "$out/bin/${browserName}${nameSuffix}" \
        --suffix-each MOZ_PLUGIN_PATH ':' "$plugins" \
        --suffix-each LD_LIBRARY_PATH ':' "$libs" \
        --prefix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))"

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications
  '';

  # Let each plugin tell us (through its `mozillaPlugin') attribute
  # where to find the plugin in its tree.
  plugins = map (x: x + x.mozillaPlugin) plugins;
  libs = map (x: x + "/lib") libs ++ map (x: x + "/lib64") libs;

  meta = {
    description =
      browser.meta.description
      + " (with plugins: "
      + (let lib = import ../../../../lib;
        in lib.concatStrings (lib.intersperse ", " (map (x: x.name) plugins)))
      + ")";
  };
}
