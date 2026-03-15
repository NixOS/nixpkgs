# Run: $(nix-build nixos/modules/hardware/facter/fingerprint/update.nix)/bin/update-fprint-devices
{
  pkgs ? import ../../../../.. { },
}:
let
  fprint-supported-devices = pkgs.libfprint.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [
      pkgs.jq
      pkgs.gawk
    ];
    buildPhase = ''
      ninja libfprint/fprint-list-supported-devices
    '';
    outputs = [ "out" ];
    installPhase = ''
      ./libfprint/fprint-list-supported-devices | \
        grep -o -E '(\b[0-9a-fA-F]{4}:[0-9a-fA-F]{4}\b)' | \
        awk '{print toupper($0)}' | \
        jq -S -R -s 'split("\n") | map(select(. != "")) | map({key: ., value: true}) | from_entries' > $out
    '';
    # we cannot disable doInstallcheck because than we are missing nativeCheckInputs dependencies
    installCheckPhase = "";
  });
in
pkgs.writeShellApplication {
  name = "update-fprint-devices";
  runtimeInputs = with pkgs; [
    coreutils
    git
  ];
  text = ''
    root="$(git rev-parse --show-toplevel)"
    target="$root/nixos/modules/hardware/facter/fingerprint/devices.json"
    cp ${fprint-supported-devices} "$target"
    echo "Updated $target"
  '';
}
