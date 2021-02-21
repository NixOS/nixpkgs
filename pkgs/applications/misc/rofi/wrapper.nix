{ symlinkJoin, lib, rofi-unwrapped, makeWrapper, wrapGAppsHook, gdk-pixbuf, hicolor-icon-theme, theme ? null, plugins ? [] }:

symlinkJoin {
  name = "rofi-${rofi-unwrapped.version}";

  paths = [
    rofi-unwrapped.out
  ] ++ (lib.forEach plugins (p: p.out));

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];
  buildInputs = [ gdk-pixbuf ];

  preferLocalBuild = true;
  passthru.unwrapped = rofi-unwrapped;

  dontWrapGApps = true;

  postBuild = ''
    rm -rf $out/bin
    mkdir $out/bin
    ln -s ${rofi-unwrapped}/bin/* $out/bin
    rm $out/bin/rofi

    gappsWrapperArgsHook
    makeWrapper ${rofi-unwrapped}/bin/rofi $out/bin/rofi \
      ''${gappsWrapperArgs[@]} \
      --prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share \
      ${lib.optionalString (plugins != []) ''--prefix XDG_DATA_DIRS : ${lib.concatStringsSep ":" (lib.forEach plugins (p: "${p.out}/share"))}''} \
      ${lib.optionalString (theme != null) ''--add-flags "-theme ${theme}"''} \
      ${lib.optionalString (plugins != []) ''--add-flags "-plugin-path $out/lib/rofi"''}

    rm $out/bin/rofi-theme-selector
    makeWrapper ${rofi-unwrapped}/bin/rofi-theme-selector $out/bin/rofi-theme-selector \
      --prefix XDG_DATA_DIRS : $out/share
  '';

  meta = rofi-unwrapped.meta // {
    priority = (rofi-unwrapped.meta.priority or 0) - 1;
  };
}
