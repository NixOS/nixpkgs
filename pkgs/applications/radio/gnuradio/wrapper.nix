{ stdenv, gnuradio, makeWrapper, python, extraPackages ? [] }:

with { inherit (stdenv.lib) appendToName makeSearchPath; };

stdenv.mkDerivation {
  name = (appendToName "with-packages" gnuradio).name;
  buildInputs = [ makeWrapper python ];

  buildCommand = ''
    mkdir -p $out/bin
    ln -s "${gnuradio}"/bin/* $out/bin/

    for file in $(find -L $out/bin -type f); do
        if test -x "$(readlink -f "$file")"; then
            wrapProgram "$file" \
                --prefix PYTHONPATH : ${stdenv.lib.concatStringsSep ":"
                                         (map (path: "$(toPythonPath ${path})") extraPackages)} \
                --prefix GRC_BLOCKS_PATH : ${makeSearchPath "share/gnuradio/grc/blocks" extraPackages}
        fi
    done
  '';

  inherit (gnuradio) meta;
}
