{ symlinkJoin
, makeWrapper
, geany
, vte
}:

symlinkJoin {
  name = "geany-with-vte-${geany.version}";

  # TODO: add geany-plugins
  paths = with geany; [ out doc man ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    # need to replace the directory since it is a symlink
    rm -r $out/bin; mkdir $out/bin
    makeWrapper ${geany}/bin/geany $out/bin/geany \
      --prefix LD_LIBRARY_PATH : ${vte}/lib
  '';

  inherit (geany.meta);
}
