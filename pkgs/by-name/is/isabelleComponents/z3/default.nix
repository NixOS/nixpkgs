{
  stdenv,
  fetchurl,
  lib,
  autoPatchelfHook,
  writeTextFile,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "z3";
  version = "4.4.0pre-4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/z3-${finalAttrs.version}.tar.gz";
    hash = "sha256-s3qNWegj3KvVrkOCFSKmpyDRDLDRKROch21zC/KohR0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${stdenv.hostPlatform.system}/z3 $out/bin
  '';

  passthru.settings =
    let
      Z3_INSTALLED = stdenv.hostPlatform.system == "x86_64-linux";
    in
    writeTextFile {
      name = "z3-settings";
      text = ''
        Z3_INSTALLED=${lib.boolToYesNo Z3_INSTALLED}
      ''
      + lib.optionalString Z3_INSTALLED ''
        Z3_HOME=${finalAttrs.finalPackage}
        Z3_SOLVER=${finalAttrs.finalPackage}/bin/z3
        Z3_VERSION=${finalAttrs.version}
      '';
      destination = "/etc/settings";
    };

  meta = {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "z3";
    homepage = "https://github.com/Z3Prover/z3";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    platforms = [ "x86_64-linux" ];
  };
})
