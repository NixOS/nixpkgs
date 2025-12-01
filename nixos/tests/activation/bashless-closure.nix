{
  nixos,
  stdenvNoCC,
  jq,
  zstd,
  cpio,
}:

let
  machine = nixos (
    { lib, modulesPath, ... }:
    {
      imports = [ "${modulesPath}/profiles/bashless.nix" ];

      fileSystems."/" = {
        device = "/dev/disk/by-partlabel/root";
        fsType = "ext4";
      };

      system.stateVersion = lib.trivial.release;
    }
  );
in
{
  # Keep this around for easier debugging, e.g. with nix why-depends.
  inherit (machine) toplevel;

  machine = stdenvNoCC.mkDerivation {
    name = "bashless-closure-machine";

    __structuredAttrs = true;

    exportReferencesGraph.closure = [ machine.toplevel ];

    nativeBuildInputs = [
      jq
    ];

    buildCommand = ''
      set +e
      jq -r '.closure[].path' < "$NIX_ATTRS_JSON_FILE" | grep bash

      exit_code=$?
      if [ $exit_code -eq 0 ]; then
          echo "Error: toplevel contains bash"
          exit 1
      fi

      touch $out
    '';
  };

  initrd = stdenvNoCC.mkDerivation {
    name = "bashless-closure-initrd";

    nativeBuildInputs = [
      zstd
      cpio
    ];

    buildCommand = ''
      set +e
      zstd -dfc ${machine.toplevel}/initrd | cpio --quiet -t | grep bash

      exit_code=$?
      if [ $exit_code -eq 0 ]; then
          echo "Error: initrd contains bash"
          exit 1
      fi

      touch $out
    '';
  };
}
