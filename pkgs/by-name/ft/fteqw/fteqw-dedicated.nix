{
  lib,
  stdenv,
  fetchFromGitHub,
  libopus,
  libxrandr,
  gnutls,
  zlib,
}@attrs:
import ./generic.nix (
  rec {
    pname = "fteqw-dedicated";
    releaseFile = "fteqw-sv";

    buildFlags = [ "sv-rel" ];

    buildInputs = [
      gnutls
      zlib
    ];

    postFixup = ''
      patchelf $out/bin/${pname} \
        --add-needed ${gnutls}/lib/libgnutls.so
    '';

    description = "Dedicated server for FTEQW";
  }
  // attrs
)
