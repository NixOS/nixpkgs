{
  lib,
  stdenvNoCC,
  writeText,
  aws-lc,
}:

stdenvNoCC.mkDerivation {
  inherit (aws-lc) version;
  pname = "rust-aws-lc-sys";

  __structuredAttrs = true;
  strictDeps = true;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    ln -s ${lib.getLib aws-lc}/lib $out/lib
    ln -s ${lib.getDev aws-lc}/include $out/include
    ln -s ${lib.getDev aws-lc}/share $out/share

    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    inherit (aws-lc.meta) license platforms maintainers;
    description = "Low-level bindings to the AWS-LC library for the Rust programming language";
    homepage = "https://github.com/aws/aws-lc-rs";
  };
}
