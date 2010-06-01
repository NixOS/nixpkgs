# nix derivation that will create a bash script that will create the go-srcs.nix file.
# 
# it can be slightly improved so it downloads properly also the OpenOffice.org upstream package,
# instead of only those 'additional' to the upstream code. By now the upstream oo.org code I wrote
# manually in the go-oo.nix.
#
# I think this looks quite ugly, but the only way I've found to know what files the program will need,
# and from what URLs, is running their './configure' with proper parameters and executing their
# './download' script.

let
  pkgsFun = import /etc/nixos/nixpkgs;
  pkgs = pkgsFun {};
in
with pkgs;

lib.overrideDerivation go_oo (attrs: {
  name = attrs.name + "-make-src";
  src = attrs.src;

  buildInputs = attrs.buildInputs ++ [ gawk ];

  # Avoid downloading what is defined in go_oo
  srcs_download = null;

  phases = [ "unpackPhase" "configurePhase" "makesh" ];

  makesh = ''
    sed -i -e '/-x $WG/d' -e "s/WGET='''/WGET='echo XXX'/" download
    ensureDir $out

    set +e
    ./download --all | grep XXX | grep -v openoffice.bouncer | awk '
      BEGIN {
        print "#!/bin/sh"
        print "echo \"{fetchurl} : [\" > go-srcs.nix"
      }
      {
         print "echo \"(fetchurl {\" >> go-srcs.nix"
         print "echo \"  url = \\\"" $2 "\\\";\" >> go-srcs.nix"
         print "echo \"  sha256 = \\\"`nix-prefetch-url " $2 "`\\\";\" >> go-srcs.nix"
         if (NF > 3)
           print "echo \"  name = \\\"" $4 "\\\";\" >> go-srcs.nix"
        print "echo \"})\" >> go-srcs.nix"
      }
      END {
        print "echo ] >> go-srcs.nix"
      }' > $out/make-go-srcs-nix.sh
    exit 0
  '';
})
