{
  lib,
  stdenv,
  fetchurl,
  picosat,
  lingeling,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "limboole";
  version = "1.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://fmv.jku.at/limboole/limboole${finalAttrs.version}.tgz";
    hash = "sha256-/H7G21CI2ihGk35HJmjSg/ukbKjoQKr28T6hFhljfLY=";
  };

  buildInputs = [
    picosat
    lingeling
  ];

  postPatch = ''
    tail -n +6 makefile.in > makefile
  '';

  dontConfigure = true;

  env = {
    NIX_CFLAGS_COMPILE = "-O3 -DNDEBUG -DVERSION=${finalAttrs.version} -DLIMBOOLE_USE_LINGELING -I${lingeling}/include -DLIMBOOLE_USE_PICOSAT -I${picosat}/include/picosat -Wall";
    NIX_LDFLAGS = "-llgl -lm -lpicosat";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 limboole $out/bin/limboole
    install -Dm755 dimacs2boole $out/bin/dimacs2boole

    runHook postInstall
  '';

  meta = {
    description = "Satisfiability and validity checker for boolean formulas";
    homepage = "https://fmv.jku.at/limboole/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fkania2
    ];
    platforms = lib.platforms.unix;
  };
})
