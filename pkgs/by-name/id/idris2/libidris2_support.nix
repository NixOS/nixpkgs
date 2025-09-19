{
  stdenv,
  lib,
  gmp,
  src,
  version,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit version src;
  pname = "libidris2_support";

  strictDeps = true;
  buildInputs = [ gmp ];

  enableParallelBuilding = true;
  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optional stdenv.isDarwin "OS=";

  buildFlags = [ "support" ];

  installTargets = "install-support";

  postInstall = ''
    mv "$out/idris2-${finalAttrs.version}/lib" "$out/lib"
    mv "$out/idris2-${finalAttrs.version}/support" "$out/share"
    rm -rf $out/idris2-${finalAttrs.version}
  '';

  meta.description = "Runtime library for Idris2";
})
