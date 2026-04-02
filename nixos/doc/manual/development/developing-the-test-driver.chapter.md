
# Developing the NixOS Test Driver {#chap-developing-the-test-driver}

The NixOS test framework is a project of its own.

It consists of roughly the following components:

 - `nixos/lib/test-driver`: The Python framework that sets up the test and runs the [`testScript`](#test-opt-testScript)
 - `nixos/lib/testing`: The Nix code responsible for the wiring, written using the (NixOS) Module System.

These components are exposed publicly through:

 - `nixos/lib/default.nix`: The public interface that exposes the `nixos/lib/testing` entrypoint.
 - `flake.nix`: Exposes the `lib.nixos`, including the public test interface.

Beyond the test driver itself, its integration into NixOS and Nixpkgs is important.

 - `pkgs/top-level/all-packages.nix`: Defines the `nixosTests` attribute, used
   by the package `tests` attributes and OfBorg.
 - `nixos/release.nix`: Defines the `tests` attribute built by Hydra, independently, but analogous to `nixosTests`
 - `nixos/release-combined.nix`: Defines which tests are channel blockers.

Finally, we have legacy entrypoints that users should move away from, but are cared for on a best effort basis.
These include `pkgs.nixosTest`, `testing-python.nix` and `make-test-python.nix`.

## Testing changes to the test framework {#sec-test-the-test-framework}

We currently have limited unit tests for the framework itself. You may run these with `nix-build -A nixosTests.nixos-test-driver`.

When making significant changes to the test framework, we run the tests on Hydra, to avoid disrupting the larger NixOS project.

For this, we use the `python-test-refactoring` branch in the `NixOS/nixpkgs` repository, and its [corresponding Hydra jobset](https://hydra.nixos.org/jobset/nixos/python-test-refactoring).
This branch is used as a pointer, and not as a feature branch.

1. Rebase the PR onto a recent, good evaluation of `nixos-unstable`
2. Create a baseline evaluation by force-pushing this revision of `nixos-unstable` to `python-test-refactoring`.
3. Note the evaluation number (we'll call it `<previous>`)
4. Push the PR to `python-test-refactoring` and evaluate the PR on Hydra
5. Create a comparison URL by navigating to the latest build of the PR and adding to the URL `?compare=<previous>`. This is not necessary for the evaluation that comes right after the baseline.

Review the removed tests and newly failed tests using the constructed URL; otherwise you will accidentally compare iterations of the PR instead of changes to the PR base.

As we currently have some flaky tests, newly failing tests are expected, but should be reviewed to make sure that
 - The number of failures did not increase significantly.
 - All failures that do occur can reasonably be assumed to fail for a different reason than the changes.
