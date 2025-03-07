---
name: Unreproducible package
about: A package that does not produce a bit-by-bit reproducible result each time it is built
title: ''
labels: [ '0.kind: enhancement', '6.topic: reproducible builds' ]
assignees: ''

---

<!--
Hello dear reporter,

Thank you for bringing attention to this issue. Your insights are valuable to
us, and we appreciate the time you took to document the problem.

I wanted to kindly point out that in this issue template, it would be beneficial
to replace the placeholder `<package>` with the actual, canonical name of the
package you're reporting the issue for. Doing so will provide better context and
facilitate quicker troubleshooting for anyone who reads this issue in the
future.

Best regards
-->

Building this package multiple times does not yield bit-by-bit identical
results, complicating the detection of Continuous Integration (CI) breaches. For
more information on this issue, visit
[reproducible-builds.org](https://reproducible-builds.org/).

Fixing bit-by-bit reproducibility also has additional advantages, such as
avoiding hard-to-reproduce bugs, making content-addressed storage more effective
and reducing rebuilds in such systems.

### Steps To Reproduce

In the following steps, replace `<package>` with the canonical name of the
package.

#### 1. Build the package

This step will build the package. Specific arguments are passed to the command
to keep the build artifacts so we can compare them in case of differences.

Execute the following command:

```
nix-build '<nixpkgs>' -A <package> && nix-build '<nixpkgs>' -A <package> --check --keep-failed
```

Or using the new command line style:

```
nix build nixpkgs#<package> && nix build nixpkgs#<package> --rebuild --keep-failed
```

#### 2. Compare the build artifacts

If the previous command completes successfully, no differences were found and
there's nothing to do, builds are reproducible.
If it terminates with the error message `error: derivation '<X>' may not be
deterministic: output '<Y>' differs from '<Z>'`, use `diffoscope` to investigate
the discrepancies between the two build outputs. You may need to add the
`--exclude-directory-metadata recursive` option to ignore files and directories
metadata (*e.g. timestamp*) differences.

```
nix run nixpkgs#diffoscopeMinimal -- --exclude-directory-metadata recursive <Y> <Z>
```

#### 3. Examine the build log

To examine the build log, use:

```
nix-store --read-log $(nix-instantiate '<nixpkgs>' -A <package>)
```

Or with the new command line style:

```
nix log $(nix path-info --derivation nixpkgs#<package>)
```

### Additional context

(please share the relevant fragment of the diffoscope output here, and any
additional analysis you may have done)

---

Add a :+1: [reaction] to [issues you find important].

[reaction]: https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/
[issues you find important]: https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc
