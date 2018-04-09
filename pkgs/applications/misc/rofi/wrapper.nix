{ stdenv, rofi-unwrapped, makeWrapper, theme ? null, lib }:

stdenv.mkDerivation {
  name = "rofi-${rofi-unwrapped.version}";
  buildInputs = [ makeWrapper ];
  preferLocalBuild = true;
  passthru = { unwrapped = rofi-unwrapped; };
  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${rofi-unwrapped}/bin/rofi $out/bin/rofi
    ${lib.optionalString (theme != null) ''wrapProgram $out/bin/rofi --add-flags "-theme ${theme}"''}
  '';

  meta = rofi-unwrapped.meta // {
    priority = (rofi-unwrapped.meta.priority or 0) - 1;
  };
}
