{
  alcom-unwrapped,
  lib,
  makeBinaryWrapper,
  runCommand,
  unityhub,
}:
let
  fhsEnv = unityhub.fhsEnv.override {
    dieWithParent = false;
  };
in
runCommand "alcom-${alcom-unwrapped.version}"
  {
    pname = "alcom";
    inherit (alcom-unwrapped) version;

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [ makeBinaryWrapper ];

    meta = alcom-unwrapped.meta // {
      priority = (alcom-unwrapped.meta.priority or lib.meta.defaultPriority) - 1;
      longDescription = ''
        Experimental GUI application to manage VRChat Unity Projects

        This wrapped package makes ALCOM launch Unity under unityhub's fhsEnv.
      '';
    };
  }
  ''
    mkdir -p "$out/bin"
    makeWrapper ${alcom-unwrapped}/bin/ALCOM "$out/bin/ALCOM" --set NIXPKGS_UNITYHUB_FHSENV ${lib.getExe fhsEnv}

    ln -s ${alcom-unwrapped}/share "$out/share"
  ''
