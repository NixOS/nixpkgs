{
  stdenv,
  fetchzip,
  callPackage,
  lib,
}:
let
  rev = "4233bf9edeff6676c01cfadd304c6806e52f1e44";

  bertTokenizer = callPackage ./bert-base-chinese-tokenizer.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "g2pw-model";
  version = "0.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://huggingface.co/datasets/rhasspy/piper-checkpoints/resolve/${rev}/zh/zh_CN/_resources/g2pw.tar.gz";
    hash = "sha256-c1gkiM6L1QH+p++q2qukgUA12A5jJmAWMtAKsTvENLo=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  patchPhase = ''
    runHook prePatch

    substituteInPlace config.py \
        --replace-fail "model_source = 'bert-base-chinese'" "model_source = '${bertTokenizer}'"

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./* "$out/"

    runHook postInstall
  '';

  passthru = {
    # Not reachable directly via `nix-update g2pwModel -u` — g2pwModel
    # isn't a top-level attribute in all-packages.nix, only a `let`
    # binding inside piper-tts's package.nix. It's updated as a step
    # of piper-tts's own updateScript: `nix-update piper-tts -u`.
    # This script also handles bert-base-chinese-tokenizer.nix.
    updateScript = [ ./update-g2pw-model.sh ];
  };

  meta = {
    description = "G2pW model used for Chinese voices in piper";
    homepage = "https://huggingface.co/datasets/rhasspy/piper-checkpoints";
    license = lib.licenses.mit;
  };
})
