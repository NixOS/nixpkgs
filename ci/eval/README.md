# Nixpkgs CI evaluation

The code in this directory is used by the [eval.yml](../../.github/workflows/eval.yml) GitHub Actions workflow to evaluate the majority of Nixpkgs for all PRs, effectively making sure that when the development branches are processed by Hydra, no evaluation failures are encountered.

Furthermore it also allows local evaluation using:

```
nix-build ci -A eval.baseline
```

The most important two arguments are:
- `--arg evalSystems`: The set of systems for which `nixpkgs` should be evaluated.
  Defaults to the four official platforms (`x86_64-linux`, `aarch64-linux`, `x86_64-darwin` and `aarch64-darwin`).
  Example: `--arg evalSystems '["x86_64-linux" "aarch64-darwin"]'`
- `--arg quickTest`: Enables testing a single chunk of the current system only for quick iteration.
  Example: `--arg quickTest true`

The following arguments can be used to fine-tune performance:
- `--max-jobs`: The maximum number of derivations to run at the same time.
  Only each [supported system](../supportedSystems.json) gets a separate derivation, so it doesn't make sense to set this higher than that number.
- `--cores`: The number of cores to use for each job.
  Recommended to set this to the amount of cores on your system divided by `--max-jobs`.
- `--arg chunkSize`: The number of attributes that are evaluated simultaneously on a single core.
  Lowering this decreases memory usage at the cost of increased evaluation time.
  If this is too high, there won't be enough chunks to process them in parallel, and will also increase evaluation time.
  The default is 5000.
  Example: `--arg chunkSize 10000`

Note that 16GB memory is the recommended minimum, while with less than 8GB memory evaluation time suffers greatly.

## Local eval with rebuilds / comparison

To compare two commits locally, first run the following on the baseline commit:

```
BASELINE=$(nix-build ci -A eval.baseline --no-out-link)
```

Then, on the commit with your changes:

```
nix-build ci -A eval.full --arg baseline $BASELINE
```

Keep in mind to otherwise pass the same set of arguments for both commands (`evalSystems`, `quickTest`, `chunkSize`).
