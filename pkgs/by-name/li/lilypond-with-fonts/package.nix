{
  lib,
  symlinkJoin,
  makeWrapper,
  lilypond,
  openlilylib-fonts,
}:

lib.appendToName "with-fonts" (symlinkJoin {
  inherit (lilypond)
    pname
    outputs
    version
    meta
    ;

  paths = [
    lilypond
  ]
  # relevant for lilypond-unstable-with-fonts
  ++ (openlilylib-fonts.override { inherit lilypond; }).all;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for p in $out/bin/*; do
      wrapProgram "$p" --set LILYPOND_DATADIR "$out/share/lilypond/${lilypond.version}"
    done

    ln -s ${lilypond.man} $man
  '';
})
