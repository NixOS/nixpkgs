{ stdenv, rofi-unwrapped, makeWrapper, hicolor-icon-theme, theme ? null }:

stdenv.mkDerivation {
  pname = "rofi";
  version = rofi-unwrapped.version;

  buildInputs = [ makeWrapper ];
  preferLocalBuild = true;
  passthru.unwrapped = rofi-unwrapped;
  buildCommand = ''
    mkdir $out
    ln -s ${rofi-unwrapped}/* $out
    rm $out/bin
    mkdir $out/bin
    ln -s ${rofi-unwrapped}/bin/* $out/bin

    rm $out/bin/rofi
    makeWrapper ${rofi-unwrapped}/bin/rofi $out/bin/rofi \
      --prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share \
      ${if theme != null then ''--add-flags "-theme ${theme}"'' else ""}

    rm $out/bin/rofi-theme-selector
    makeWrapper ${rofi-unwrapped}/bin/rofi-theme-selector $out/bin/rofi-theme-selector \
      --prefix XDG_DATA_DIRS : $out/share
  '';

  meta = rofi-unwrapped.meta // {
    priority = (rofi-unwrapped.meta.priority or 0) - 1;
  };
}
