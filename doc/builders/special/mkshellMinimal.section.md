# pkgs.mkShellMinimal {#sec-pkgs-mkShellMinimal}

`pkgs.mkShellMinimal` is similar to `mkShell` but does not rely on the
`stdenv` or even `bash`. It has a much smaller footprint and feature-set than
`mkShell` and is useful if you care about your closure size or being very explicit
about the dependencies (i.e. coreutils vs. busybox).

## Usage {#sec-pkgs-mkShellMinimal-usage}

```nix
let
  nixpkgs = import <nixpkgs> { };
in
with nixpkgs;
mkShellMinimal {
  name = "my-minimal-shell";

  # Place your dependencies here
  packages = [ ];

  # You can do typical environment variable setting
  FOO = "bar";
}
```

This shell can be started with `nix-shell` and has zero dependencies.

```bash
❯ nix path-info -rSsh $(nix-build shell.nix)
This derivation is not meant to be built, unless you want to capture the dependency closure.

/nix/store/8ka1hnlf06z3h2rpd00b4d9w5yxh0n39-setup        	 376.0 	 376.0
/nix/store/nprykggfqhdkn4r5lxxknjvlqc4qm1yl-builder.sh   	 280.0 	 280.0
/nix/store/xd8d72ccrxhaz3sxlmiqjnn1z0zwfhm8-my-minimal-shell	 744.0 	   1.4K
```

`mkShellMinimal` is buildable as opposed to `mkShell`. This is useful if you want to upload the
transitive closure of the shell to a remote nix-store.
