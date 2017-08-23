{ stdenv }:

stdenv.mkDerivation {
  name = "expand-response-params";
  src = ./expand-response-params.c;
  buildCommand = ''
    # Work around "stdenv-darwin-boot-2 is not allowed to refer to path /nix/store/...-expand-response-params.c"
    cp "$src" expand-response-params.c
    "$CC" -std=c99 -O3 -o "$out" expand-response-params.c
    strip -S $out
    ${stdenv.lib.optionalString stdenv.hostPlatform.isLinux "patchelf --shrink-rpath $out"}
  '';
}
