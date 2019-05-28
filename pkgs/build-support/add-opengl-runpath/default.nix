{ lib, stdenv, mesa }:

stdenv.mkDerivation {
  name = "add-opengl-runpath";

  driverLink = "/run/opengl-driver" + lib.optionalString stdenv.isi686 "-32";
  swrast = if mesa ? swrast then mesa.swrast else null;

  buildCommand = ''
    mkdir -p $out/nix-support
    substituteAll ${./setup-hook.sh} $out/nix-support/setup-hook
  '';
}
