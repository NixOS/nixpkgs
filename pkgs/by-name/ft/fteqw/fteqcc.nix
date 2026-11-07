{
  lib,
  stdenv,
  fetchFromGitHub,
  libopus,
  libxrandr,
  zlib,
}@attrs:
import ./generic.nix (
  {
    pname = "fteqcc";

    buildFlags = [ "qcc-rel" ];

    buildInputs = [
      zlib
    ];

    description = "User friendly QuakeC compiler";
  }
  // attrs
)
