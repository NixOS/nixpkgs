{ runCommand, lib, python312 }:

firmware:

let
  extraArgs = lib.optionalAttrs (firmware ? meta) { inherit (firmware) meta; };
in

runCommand "${firmware.name}-xz" ({
  nativeBuildInputs = [ python312 ];
  allowedRequisites = [];
} // extraArgs) ''
  python ${./compress-firmware.py} ${firmware}/lib/firmware $out/lib/firmware

  if find $out -xtype l | grep .; then
    echo "Found dead symlinks!"
    exit 1
  fi
''
