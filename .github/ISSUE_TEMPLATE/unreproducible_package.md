---
name: Unreproducible package
about: A package that does not produce a bit-by-bit reproducible result each time it is built
title: ''
labels: [ '0.kind: enhancement', '6.topic: reproducible builds' ]
assignees: ''

---

Building this package twice does not produce the bit-by-bit identical result each time, making it harder to detect CI breaches. You can read more about this at https://reproducible-builds.org/ .

Fixing bit-by-bit reproducibility also has additional advantages, such as avoiding hard-to-reproduce bugs, making content-addressed storage more effective and reducing rebuilds in such systems.

### Steps To Reproduce

```
nix-build '<nixpkgs>' -A ... && nix-build '<nixpkgs>' -A ... --check --keep-failed
```

If this command completes successfully, no differences where found. However, when it ends in `error: derivation '<X>' may not be deterministic: output '<Y>' differs from '<Z>'`, you can use `diffoscope <Y> <Z>` to analyze the differences in the output of the two builds.

To view the build log of the build that produced the artifact in the binary cache:

```
nix-store --read-log $(nix-instantiate '<nixpkgs>' -A ...)
```

### Additional context

(please share the relevant fragment of the diffoscope output here,
and any additional analysis you may have done)
