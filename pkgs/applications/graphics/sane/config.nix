{ stdenv }:

{ paths }:

with stdenv.lib;
let installSanePath = path: ''
      find "${path}/lib/sane" -not -type d -maxdepth 1 | while read backend; do
        ln -s $backend $out/lib/sane/$(basename $backend)
      done

      find "${path}/etc/sane.d" -not -type d -maxdepth 1 | while read conf; do
        ln -s $conf $out/etc/sane.d/$(basename $conf)
      done

      find "${path}/etc/sane.d/dll.d" -not -type d -maxdepth 1 | while read conf; do
        ln -s $conf $out/etc/sane.d/dll.d/$(basename $conf)
      done
    '';
in
stdenv.mkDerivation {
  name = "sane-config";
  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/etc/sane.d $out/etc/sane.d/dll.d $out/lib/sane
  '' + concatMapStrings installSanePath paths;
}
