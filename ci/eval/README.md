# Nixpkgs CI evaluation

The code in this directory is used by the [eval.yml](../../.github/workflows/eval.yml) GitHub Actions workflow to evaluate the majority of Nixpkgs for all PRs, effectively making sure that when the development branches are processed by Hydra, no evaluation failures are encountered.

Furthermore it also allows local evaluation using
```
nix-build ci -A eval.full \
  --max-jobs 4 \
  --cores 2 \
  --arg chunkSize 10000 \
  --arg evalSystems '["x86_64-linux" "aarch64-darwin"]'
```

- `--max-jobs`: The maximum number of derivations to run at the same time. Only each [supported system](../supportedSystems.nix) gets a separate derivation, so it doesn't make sense to set this higher than that number.
- `--cores`: The number of cores to use for each job. Recommended to set this to the amount of cores on your system divided by `--max-jobs`.
- `chunkSize`: The number of attributes that are evaluated simultaneously on a single core. Lowering this decreases memory usage at the cost of increased evaluation time. If this is too high, there won't be enough chunks to process them in parallel, and will also increase evaluation time.
- `evalSystems`: The set of systems for which `nixpkgs` should be evaluated. Defaults to the four official platforms (`x86_64-linux`, `aarch64-linux`, `x86_64-darwin` and `aarch64-darwin`).

A good default is to set `chunkSize` to 10000, which leads to about 3.6GB max memory usage per core, so suitable for fully utilising machines with 4 cores and 16GB memory, 8 cores and 32GB memory or 16 cores and 64GB memory.

Note that 16GB memory is the recommended minimum, while with less than 8GB memory evaluation time suffers greatly.
