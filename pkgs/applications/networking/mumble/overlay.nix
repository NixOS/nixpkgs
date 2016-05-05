{ stdenv, lib, which, file, mumble, mumble_i686
}:

let
  binPath = lib.makeBinPath [ which file ];
in stdenv.mkDerivation {
  name = "mumble-overlay-${mumble.version}";

  inherit (mumble) src;

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/lib
    ln -s ${mumble}/lib/libmumble.so.1.* $out/lib/libmumble.so.1
    ${lib.optionalString (mumble_i686 != null) ''
      mkdir -p $out/lib32
      ln -s ${mumble_i686}/lib/libmumble.so.1.* $out/lib32/libmumble.so.1
    ''}
    install -Dm755 scripts/mumble-overlay $out/bin/mumble-overlay
    sed -i "s,/usr/lib,$out/lib,g" $out/bin/mumble-overlay
    sed -i '2iPATH="${binPath}:$PATH"' $out/bin/mumble-overlay
  '';
}
