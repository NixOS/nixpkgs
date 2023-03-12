{ lib, symlinkJoin, makeWrapper, bash, wine, nine32, nine64 }:

symlinkJoin {
  inherit (nine64) name pname version meta;

  nativeBuildInputs = [ makeWrapper ];
  paths = [ wine ];

  postBuild = ''
    [[ -x "$out"/bin/wine ]] && wrapProgram "$out"/bin/wine \
      --prefix WINEDLLPATH ':' ${lib.escapeShellArg "${nine32}/lib/wine"} \
      --prefix WINEDLLPATH ':' ${lib.escapeShellArg "${nine64}/lib/wine"}

    [[ -x "$out"/bin/wine64 ]] && wrapProgram "$out"/bin/wine64 \
      --prefix WINEDLLPATH ':' ${lib.escapeShellArg "${nine32}/lib/wine"} \
      --prefix WINEDLLPATH ':' ${lib.escapeShellArg "${nine64}/lib/wine"}

    # Convenience symlink for ninewinecfg
    # Many wine commands like wineboot resolve to `wine $0.exe "$@"`
    ln -s wineboot "$out"/bin/ninewinecfg
  '';
}
