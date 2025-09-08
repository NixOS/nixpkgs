let
  pkgs = ((import <nixpkgs>) { overlays = [ ]; });
  lib = pkgs.lib;
  dir = builtins.toString ./.;
in
pkgs.writeShellScriptBin "get-podman-config-files" ''
  dir="''${1:-${dir}}"
  mkdir -p "$dir/root/etc" "$dir/root/run"
  podmanExe="${lib.getExe pkgs.podman}"

  function cleanup() {
    true
      "$podmanExe" container kill temp-buildah &>/dev/null || true
      "$podmanExe" container rm temp-buildah &>/dev/null || true
  }
  trap cleanup EXIT
  cleanup

  ${lib.getExe pkgs.podman} run -d --name temp-buildah 'quay.io/buildah/stable:latest'
  echo "Writing files to '$dir/root/etc' ..."

  "$podmanExe" cp temp-buildah:/etc/containers "$dir/root/etc/"
  ${pkgs.findutils}/bin/find "$dir/root" -type d -empty -delete
''
