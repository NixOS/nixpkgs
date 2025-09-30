{
  lib,
  n2,
  runCommand,
}:

let
  mainProgram = "ninja";
  pname = "n2-as-ninja";
  inherit (n2) version;
in
runCommand "${pname}-${version}"
  {
    inherit pname version;

    passthru.unwrapped = n2;

    meta = n2.meta // {
      inherit mainProgram;
      description = "n2 as a drop-in replacement for ninja";

      # The code that produces the wrapper is in the Nixpkgs repo, and the
      # Nixpkgs repo is MIT Licensed.
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ sandarukasa ];
    };
  }
  ''
    mkdir -p $out/bin/
    ln -s ${n2}/bin/${n2.meta.mainProgram} $out/bin/${mainProgram}
  ''
