{ stdenv }:

{ paths }:

with stdenv.lib;
let installSanePath = path: ''
      if [ -e "${path}/lib/sane" ]; then
        find "${path}/lib/sane" -maxdepth 1 -not -type d | while read backend; do
          ln -s "$backend" "$out/lib/sane/$(basename "$backend")"
        done
      fi

      if [ -e "${path}/etc/sane.d" ]; then
        find "${path}/etc/sane.d" -maxdepth 1 -not -type d | while read conf; do
          name="$(basename $conf)"
          if [ "$name" = "dll.conf" ] || [ "$name" = "saned.conf" ] || [ "$name" = "net.conf" ]; then
            cat "$conf" >> "$out/etc/sane.d/$name"
          else
            ln -s "$conf" "$out/etc/sane.d/$name"
          fi
        done
      fi

      if [ -e "${path}/etc/sane.d/dll.d" ]; then
        find "${path}/etc/sane.d/dll.d" -maxdepth 1 -not -type d | while read conf; do
          ln -s "$conf" "$out/etc/sane.d/dll.d/$(basename $conf)"
        done
      fi
    '';
in
stdenv.mkDerivation {
  name = "sane-config";
  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/etc/sane.d $out/etc/sane.d/dll.d $out/lib/sane
  '' + concatMapStrings installSanePath paths;
}
