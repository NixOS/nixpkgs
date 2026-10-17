{
  lib,
  stdenv,
  unsecvars,
  linuxHeaders,
  sourceProg,
  debug ? false,
}:
# For testing:
# $ nix-build -E 'with import <nixpkgs> {}; pkgs.callPackage ./wrapper.nix { sourceProg = "${pkgs.hello}/bin/hello"; debug = true; }'
stdenv.mkDerivation {
  name = "security-wrapper-${baseNameOf sourceProg}";
  buildInputs = [ linuxHeaders ];
  dontUnpack = true;
  CFLAGS = [
    ''-DSOURCE_PROG="${sourceProg}"''
  ]
  ++ (
    if debug then
      [
        "-Werror"
        "-Og"
        "-g"
      ]
    else
      [
        "-Wall"
        "-O2"
      ]
  );
  dontStrip = debug;
  installPhase = ''
    mkdir -p $out/bin
    $CC $CFLAGS ${./wrapper.c} -I${unsecvars} -o $out/bin/security-wrapper
  '';

  # HACK: Avoid leaking all of `buildInputs` into runtime closure
  # FIXME when/if https://github.com/NixOS/nixpkgs/issues/83667 is resolved
  postFixup = lib.optionalString stdenv.hostPlatform.isStatic ''
    rm $out/nix-support/propagated-build-inputs
  '';
}
