{ appimageTools, autoPatchelfHook, stdenv, desktop-file-utils
  , hicolor-icon-theme,gtk3, gsettings-desktop-schemas }:

# fetchzip is for compatibility, bother AppImage builder about that :
# https://docs.appimage.org/packaging-guide/distribution.html#do-not-put-appimages-into-other-archives

# some src.url can be hard to follow, you can download them with firefox
# "simple mass downloader" addon then use the "export selected item to file"
# available in the right menu.

{
  pname,
  version,
  src,
  meta,
  ...
} @attrs:
  let
    name = "${attrs.pname}-${attrs.version}.AppImage";
    attrs' = builtins.removeAttrs attrs ["version" "pname"];
    #nativeBuildInputs = [  ];

    #appimageTools
  in appimageTools.wrapType2 (attrs' //  {
    inherit name src;
    /* extraPkgs = ps:
      appimageTools.defaultFhsEnvArgs.multiPkgs ps
      ++ (with ps; [ desktop-file-utils autoPatchelfHook ]); */

    /* buildInputs = [ desktop-file-utils autoPatchelfHook ]; */
    /* extraBuildCommands = */
    /* extraInstallCommands = attrs.extraInstallCommands or ''
      # fixup and install desktop file
      desktopitem="$(ls $out/*.desktop)"
      desktop-file-install "$desktopitem" --dir $out/share/applications \
        --set-key Exec --set-value $out/bin/${name}
      mv $out/share/applications/"$desktopitem" $out/share/applications/$name.desktop

      #PLANNED: write a more generic code to read icon path from $desktopitem
      #install -m 444 -D $icon $out/share/icons/hicolor/512x512/apps/$icon
    ''; */

    meta = {
      license = stdenv.lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      description = throw "please write meta.description";
      maintainers = throw "please write meta.maintainers";
    } // attrs'.meta;
} // attrs')
