# Specific files for the job images.
#
# - `basicRoot`: Some basic root files for the `jobImages.nix`.
# - `fakeNixpkgs`: A fake Nixpkg directory which is set as `NIX_PATH=nixpkgs:<path>`
#                  which throws on load.
# - `nixConfig`: The Nix config with some options.
# - `containers`:
#   These are some files which are copied to the job images needed for
#   `buildah` (`podman`):
#
#   ```bash
#   podman create --name temp-buildah quay.io/buildah/stable:latest
#   podman cp temp-buildah:/etc/containers ./etc/
#   find ./etc -type d -empty -delete
#   podman container rm temp-buildah
#```
#
{ pkgs, ... }:
let

  # We need proper derivations to add it to the nixImageBase.
  mkDrv =
    name: src:
    pkgs.stdenv.mkDerivation {
      inherit name src;
      installPhase = ''
        mkdir -p $out
        cp -r $src/* $out/
      '';
    };
in
{
  basicRoot = mkDrv "basic-root-files" ./basicRoot;
  containers = mkDrv "containers-files" ./containers;
  fakeNixpkgs = mkDrv "fake-nixpkgs" ./fake-nixpkgs;

  nixConfig = pkgs.writeTextFile {
    name = "nix.conf";
    destination = "/etc/nix/nix.conf";
    text = ''
      accept-flake-config = true
      experimental-features = nix-command flakes
      max-jobs = auto
    '';
  };
}
