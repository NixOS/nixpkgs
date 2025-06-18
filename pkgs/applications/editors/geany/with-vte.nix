{
  symlinkJoin,
  makeWrapper,
  geany,
  vte,
}:

symlinkJoin {
  name = "geany-with-vte-${geany.version}";

  # TODO: add geany-plugins
  paths = with geany; [
    out
    doc
    man
  ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    # need to replace the directory since it is a symlink
    rm -r $out/bin; mkdir $out/bin
    makeWrapper ${geany}/bin/geany $out/bin/geany \
      --prefix LD_LIBRARY_PATH : ${vte}/lib
  '';

  meta = {
    # can't just "inherit (geany) meta;" because:
    # error: derivation '/nix/store/...-geany-with-vte-2.0.drv' does not have wanted outputs 'man'
    inherit (geany.meta)
      description
      longDescription
      homepage
      license
      maintainers
      platforms
      mainProgram
      ;
  };
}
