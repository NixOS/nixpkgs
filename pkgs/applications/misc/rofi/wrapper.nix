{ stdenv, rofi-unwrapped, makeWrapper, theme ? null }:

if theme == null then rofi-unwrapped else
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
    makeWrapper ${rofi-unwrapped}/bin/rofi $out/bin/rofi --add-flags "-theme ${theme}"
  '';

  meta = rofi-unwrapped.meta // {
    priority = (rofi-unwrapped.meta.priority or 0) - 1;
  };
}
