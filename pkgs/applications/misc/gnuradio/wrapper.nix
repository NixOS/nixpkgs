{ stdenv, gnuradio, makeWrapper, python
, extraPackages ? [] }:

with stdenv.lib;

stdenv.mkDerivation {
  name = (appendToName "with-packages" gnuradio).name;
  buildInputs = [ makeWrapper python ];

  buildCommand = ''
    mkdir -p $out/bin
    ln -s "${gnuradio}"/bin/* $out/bin/

    for file in $(find $out/bin -type f -executable); do
        wrapProgram "$file" \
            --prefix PYTHONPATH : ${stdenv.lib.concatStringsSep ":"
                                     (map (path: "$(toPythonPath ${path})") extraPackages)} \
            --prefix GRC_BLOCKS_PATH : ${makeSearchPath "share/gnuradio/grc/blocks" extraPackages}
    done

  '';
  inherit (gnuradio) meta;
}
