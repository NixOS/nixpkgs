{ lib, stdenv }:

stdenv.mkDerivation {
  name = "add-opengl-runpath";

  driverLink = "/run/opengl-driver" + lib.optionalString stdenv.isi686 "-32";

  buildCommand = ''
    mkdir -p $out/nix-support
    substituteAll ${./setup-hook.sh} $out/nix-support/setup-hook
  '';

  meta = {
    description = "Build support script to set RUNPATH so that driver libraries in /run/opengl-driver(-32)/lib can be found";
  }
}
