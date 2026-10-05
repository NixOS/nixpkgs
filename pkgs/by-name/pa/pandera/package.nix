{
  lib,
  python3Packages,
}:

python3Packages.toPythonApplication (
  python3Packages.pandera.overridePythonAttrs (oldAttrs: {
    # The CLI's three subcommands each lazily import a different extra:
    # validate/infer need a dataframe backend and the serialization formats,
    # generate needs hypothesis.
    dependencies =
      oldAttrs.dependencies
      ++ lib.concatMap (extra: oldAttrs.optional-dependencies.${extra}) [
        "cli"
        "io"
        "narwhals"
        "pandas"
        "polars"
        "pyarrow"
        "strategies"
      ];
  })
)
