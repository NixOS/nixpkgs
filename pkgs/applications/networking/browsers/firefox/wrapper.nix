{ stdenv, lib, browser, makeDesktopItem, makeWrapper, plugins, gst_plugins, libs, gtk_modules
, browserName, desktopName, nameSuffix, icon, libtrick ? true
}:

let p = builtins.parseDrvName browser.name; in

stdenv.mkDerivation {
  name = "${p.name}-with-plugins-${p.version}";

  desktopItem = makeDesktopItem {
    name = browserName;
    exec = browserName + " %U";
    inherit icon;
    comment = "";
    desktopName = desktopName;
    genericName = "Web Browser";
    categories = "Application;Network;WebBrowser;";
    mimeType = stdenv.lib.concatStringsSep ";" [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  buildInputs = [makeWrapper] ++ gst_plugins;

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
        --suffix-each GTK_PATH ':' "$gtk_modules" \
        --suffix-each LD_PRELOAD ':' "$(cat $(filterExisting $(addSuffix /extra-ld-preload $plugins)))" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
        --prefix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))" \
        --set MOZ_OBJDIR "$(ls -d "${browser}/lib/${browserName}"*)"

    ${ lib.optionalString libtrick
    ''
    sed -e "s@exec @exec -a '$out/bin/${browserName}${nameSuffix}' @" -i "$out/bin/${browserName}${nameSuffix}"
    libdirname="$(echo "${browser}/lib/${browserName}"*)"
    libdirbasename="$(basename "$libdirname")"
    mkdir -p "$out/lib/$libdirbasename"
    ln -s "$libdirname"/* "$out/lib/$libdirbasename"
    script_location="$(mktemp "$out/lib/$libdirbasename/${browserName}${nameSuffix}.XXXXXX")"
    mv "$out/bin/${browserName}${nameSuffix}" "$script_location"
    ln -s "$script_location" "$out/bin/${browserName}${nameSuffix}"
    ''
    }

    if [ -e "${browser}/share/icons" ]; then
        mkdir -p "$out/share"
        ln -s "${browser}/share/icons" "$out/share/icons"
    else
        mkdir -p "$out/share/icons/hicolor/128x128/apps"
        ln -s "$out/lib/$libdirbasename/browser/icons/mozicon128.png" \
            "$out/share/icons/hicolor/128x128/apps/${browserName}.png"
    fi

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications

    # For manpages, in case the program supplies them
    mkdir -p $out/nix-support
    echo ${browser} > $out/nix-support/propagated-user-env-packages
  '';

  preferLocalBuild = true;

  # Let each plugin tell us (through its `mozillaPlugin') attribute
  # where to find the plugin in its tree.
  plugins = map (x: x + x.mozillaPlugin) plugins;
  libs = map (x: x + "/lib") libs ++ map (x: x + "/lib64") libs;
  gtk_modules = map (x: x + x.gtkModule) gtk_modules;

  meta = {
    description =
      browser.meta.description
      + " (with plugins: "
      + lib.concatStrings (lib.intersperse ", " (map (x: x.name) plugins))
      + ")";
  };
}
