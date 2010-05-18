{ stdenv, browser, makeDesktopItem, makeWrapper, plugins
, browserName ? "firefox"
, desktopName ? "Firefox"
, nameSuffix ? ""
}:

stdenv.mkDerivation {
  name = browser.name + "-with-plugins";

  desktopItem = makeDesktopItem {
    name = browserName;
    exec = browserName;
    icon = "${browser}/lib/${browser.name}/icons/mozicon128.png";
    comment = "";
    desktopName = desktopName;
    genericName = "Web Browser";
    categories = "Application;Network;";
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
        --prefix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))"

    ensureDir $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications
  '';

  # Let each plugin tell us (through its `mozillaPlugin') attribute
  # where to find the plugin in its tree.
  plugins = map (x: x + x.mozillaPlugin) plugins;

  meta = {
    description =
      browser.meta.description
      + " (with plugins: "
      + (let lib = import ../../../../lib;
        in lib.concatStrings (lib.intersperse ", " (map (x: x.name) plugins)))
      + ")";
  };
}
