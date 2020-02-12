# Updated fetchCargo behavior

Changes to the `fetchcargo.nix` behavior that cause changes to the `cargoSha256`
are somewhat disruptive, so historically we've added conditionals to provide
backwards compatibility. We've now accumulated enough of these that it makes
sense to do a clean sweep updating hashes, and delete the conditionals in the
fetcher to simplify maintenance and implementation complexity. These
conditionals are:

1. When cargo vendors dependencies, it generates a config. Previously, we were
   hard-coding our own config, but this fails if there are git dependencies. We
   have conditional logic to sometimes copy the vendored cargo config in, and
   sometimes not.

2. When a user updates the src package, they may forget to update the
   `cargoSha256`. We have an opt-in conditional flag to add the `Cargo.lock`
   into the vendor dir for inspection and compare at build-time, but it defaults
   to false.

3. We were previously vendoring into a directory with a recursive hash, but
   would like to vendor into a compressed tar.gz file instead, for the reasons
   specified in the git commit message adding this feature.


## Migration plan

1. (DONE in this PR) Implement `fetchCargoTarball` as a separate, clean fetcher
   implementation along-side `fetchcargo`. Rename `verifyCargoDeps` (default
   false) to `legacyCargoFetcher` (default true), which switches the fetcher
   implementation used. Replace `verifyCargoDeps = true;` with
   `legacyCargoFetcher = false;` in Rust applications.

2. Send a treewide Rust PR that sets `legacyCargoFetcher = true;` in all Rust
   applications not using this (which is ~200 of them), with a note to
   maintainers to delete if updating the package. Change the default in
   `buildRustPackage` to false.

3. Go through all Rust src packages deleting the `legacyCargoFetcher = false;`
   line and re-computing the `cargoSha256`, merging as we go.

4. Delete the `fetchcargo.nix` implementation entirely and also remove:
  - All overrides in application-level packages
  - The `fetchcargo-default-config.toml` and conditionals around using it when
    no `$CARGO_CONFIG` exists
  - This README.md file
