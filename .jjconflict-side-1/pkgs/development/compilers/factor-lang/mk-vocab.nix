{
  stdenv,
}@initAttrs:

drvArgs:

(stdenv.mkDerivation drvArgs).overrideAttrs (
  finalAttrs:
  {
    name ? "${finalAttrs.pname}-${finalAttrs.version}",
    vocabName ? finalAttrs.pname or name,
    vocabRoot ? "extra",
    # Runtime libraries needed to run this vocab, handed to runtime wrapper
    extraLibs ? [ ],
    # Extra vocabularies, handed to runtime wrapper
    extraVocabs ? [ ],
    # Extra binaries in PATH, handed to runtime wrapper
    extraPaths ? [ ],
    ...
  }@attrs:
  {
    inherit vocabName vocabRoot;
    installPhase =
      # Default installer
      # 1. If lib/factor/<vocabRoot>/<vocabName> exists, copy all vocab roots
      #    under lib/factor/* to out/.
      # 2. If <vocabName> exists, copy all directories next to <vocabName> to
      #    out/.
      # These two carry over package-defined vocabs that the name-giving vocab
      # depends on.
      # 3. Otherwise, copy all .factor and .txt files to out/.  For simple
      #    single-vocab packages.
      attrs.installPhase or ''
        runHook preInstall
        mkdir -p "$out/lib/factor/${finalAttrs.vocabRoot}/${finalAttrs.vocabName}"
        if [ -d "lib/factor/${finalAttrs.vocabRoot}/${finalAttrs.vocabName}" ]; then
            find lib/factor -mindepth 1 -maxdepth 1 -type d -exec \
                cp -r -t "$out/lib/factor" {} \+
        elif [ -d "${finalAttrs.vocabName}" ]; then
            fname="${finalAttrs.vocabName}"
            base=$(basename "${finalAttrs.vocabName}")
            root=''${fname%$base}
            root=''${root:-.}
            find "$root" -mindepth 1 -maxdepth 1 -type d \
                -not \( -name bin -or -name doc -or -name lib \) -exec \
                cp -r -t "$out/lib/factor/${finalAttrs.vocabRoot}" {} \+
        else
            cp *.factor *.txt "$out/lib/factor/${finalAttrs.vocabRoot}/${finalAttrs.vocabName}"
        fi
        runHook postInstall
      '';

    passthru = {
      inherit extraLibs extraVocabs extraPaths;
    };

    meta = attrs.meta or { };
  }
)
