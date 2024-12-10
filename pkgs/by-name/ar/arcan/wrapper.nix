{
  arcan,
  makeWrapper,
  symlinkJoin,
  appls ? [ ],
  name ? "arcan-wrapped",
}:

symlinkJoin rec {
  inherit name;

  paths = appls ++ [ arcan ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for prog in ${placeholder "out"}/bin/*; do
      wrapProgram $prog \
        --prefix PATH ":" "${placeholder "out"}/bin" \
        --set ARCAN_APPLBASEPATH "${placeholder "out"}/share/arcan/appl/" \
        --set ARCAN_BINPATH "${placeholder "out"}/bin/arcan_frameserver" \
        --set ARCAN_LIBPATH "${placeholder "out"}/lib/" \
        --set ARCAN_RESOURCEPATH "${placeholder "out"}/share/arcan/resources/" \
        --set ARCAN_SCRIPTPATH "${placeholder "out"}/share/arcan/scripts/"
    done
  '';
}
# TODO: set ARCAN_STATEBASEPATH to $HOME/.arcan/resources/savestates/ - possibly
# via a suitable script
# TODO: set ARCAN_FONTPATH to a set of default-but-configurable fontset
