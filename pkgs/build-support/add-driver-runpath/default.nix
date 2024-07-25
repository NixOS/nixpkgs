{ lib, stdenv }:

stdenv.mkDerivation {
  name = "add-driver-runpath";

  # Named "opengl-driver" for legacy reasons, but it is the path to
  # hardware drivers installed by NixOS
  driverLink = "/run/opengl-driver" + lib.optionalString stdenv.isi686 "-32";

  buildCommand = ''
    mkdir -p $out/nix-support
    substituteAll ${./setup-hook.sh} $out/nix-support/setup-hook
  '';
}
