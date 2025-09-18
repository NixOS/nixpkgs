# Create a derivation that contains aspell and selected dictionaries.
# Composition is done using `pkgs.buildEnv`.
# Beware of that `ASPELL_CONF` used by this derivation is not always
# respected by libaspell (#28815) and in some cases, when used as
# dependency by another derivation, the passed dictionaries will be
# missing. However, invoking aspell directly should be fine.

{
  lib,
  buildEnv,
  makeBinaryWrapper,
  aspell,
  extraDicts ? [ ],
}:

buildEnv {
  inherit (lib.appendToName "with-dicts" aspell) name version;

  nativeBuildInputs = [ makeBinaryWrapper ];

  paths = [ aspell ] ++ extraDicts;

  # Lib for the dicts and share for the man pages
  pathsToLink = [
    "/lib"
    "/share"
  ];

  postBuild = ''
    mkdir -p "$out/bin"

    pushd "${aspell}/bin"
    for prg in *; do
      if [ -f "$prg" ]; then
        makeWrapper "${aspell}/bin/$prg" "$out/bin/$prg" \
          --set-default ASPELL_CONF "dict-dir $out/lib/aspell"
      fi
    done
    popd

  '';
  meta = {
    # So meta.pos still works normally
    # Unless if just `inherit (aspell) meta;`
    # was done
    inherit (aspell.meta)
      description
      longDescription
      homepage
      changelog
      license
      mainProgram
      maintainers
      ;
  };
}
