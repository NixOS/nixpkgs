{
  lib,
  python3Packages,

  # extras
  withAlignment ? true,
  withHTTP ? true,
  withJapanese ? true,
  withTrain ? true,
}:

python3Packages.toPythonApplication (
  python3Packages.piper-tts.overridePythonAttrs (oldAttrs: {
    dependencies =
      oldAttrs.dependencies
      ++ lib.optionals withAlignment oldAttrs.optional-dependencies.alignment
      ++ lib.optionals withHTTP oldAttrs.optional-dependencies.http
      ++ lib.optionals withJapanese oldAttrs.optional-dependencies.ja
      ++ lib.optionals withTrain oldAttrs.optional-dependencies.train;

    pythonImportsCheck =
      oldAttrs.pythonImportsCheck
      # needs torch, so only checkable with the train extra
      ++ lib.optionals withTrain [ "piper.train.vits.monotonic_align" ];
  })
)
