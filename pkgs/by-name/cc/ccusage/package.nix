{
  stdenv,
  lib,
  fetchFromGitHub,
  bun,
  makeWrapper,
}:

let
  version = "14.1.2";
  src = fetchFromGitHub {
    owner = "ryoppippi";
    repo = "ccusage";
    tag = "v${version}";
    hash = "sha256-RnGB2lCvBuHitcuAl/m98OJBmpRF6HrJMx328ZCCzRo=";
  };
  ccusage-deps = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "ccusage-deps";
    nativeBuildInputs = [ bun ];
    buildPhase = ''
      runHook preBuild

      bun install --no-save --ignore-scripts

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r node_modules $out/

      runHook postInstall
    '';
    outputHash = "sha256-Mk+sb5J6degg5qR11L63mjORa867enz6FeB3jKuXz8A=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  });

in
stdenv.mkDerivation {
  inherit version src;
  pname = "ccusage";
  nativeBuildInputs = [
    bun
    makeWrapper
  ];
  buildPhase = ''
    runHook preBuild

    ln -s ${ccusage-deps}/node_modules ./node_modules

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/ccusage
    cp -r . $out/share/ccusage/

    makeWrapper ${bun}/bin/bun $out/bin/ccusage \
      --chdir "$out/share/ccusage" \
      --add-flags "run ./src/index.ts"

    runHook postInstall
  '';

  meta = {
    description = "CLI tool for analyzing Claude Code usage from local JSONL files";
    mainProgram = "ccusage";
    homepage = "https://github.com/ryoppippi/ccusage";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eleloi ];
  };
}
