## Go toolchain/builder upgrade policy

Go promises that "programs written to the Go 1 specification will continue to compile and run correctly, unchanged, over the lifetime of that specification" [1].
Newer toolchain versions should build projects developed against older toolchains without problems.

There are however Go packages depending on internal APIs of the toolchain/runtime/stdlib that are not covered by the Go compatibility promise.
These packages may break on toolchain updates.
We name packages that (often) break on toolchain updates `toolchain-breaking`.

There is another set of packages that depends on the toolchain, but in another way:
Packages providing development support for the Go language (like `gopls`, `golangci-lint`,...) must be compiled with the version they should be used for.
If `gopls` is compiled for Go 1.23, it won't work for projects that require Go 1.24.
We name packages that must be built with the latest toolchain to work as expected `toolchain-latest`.

Go only ever has two supported toolchains. With a new minor release, the second last Go toolchain is automatically end of life, meaning it won't receive security updates anymore.

Based on this, we align on the following policy for toolchain/builder upgrades:

1. Default toolchain (the `go` package) and builder (`buildGoModule`) are upgraded to the latest minor release of Go as soon as it is released.
  As it is a mass rebuild, this package will be made against the `staging` branch.

2. The `go_latest` toolchain and the `buildGoLatestModule` are also bumped directly after release, but the update goes to the `master` branch.

    Packages in `toolchain-latest` SHOULD use `go_latest`/`buildGoLatestModule`.
    Packages in nixpkgs MUST only use this toolchain/builder if they have a good reason to do so
    A comment MUST be added explaining why this is the case for a certain package.
    It is important to keep the number of packages using this builder within nixpkgs low, so the bump won't cause a mass rebuild.

    Consumer outside of nixpkgs on the other hand MAY rely on this toolchain/builder if they prefer being upgraded earlier to the newest toolchain.

3. Packages in `toolchain-breaking` SHOULD pin a toolchain version by using a builder with a fixed Go version (`buildGo1xxModule`).
  The use of `buildGo1xxModule` MUST be accompanied with a comment explaining why this has a dependency on a specific Go version.
  The comment should target the Go team in nixpkgs and ease their work in case they have to touch the package (see 5.).

4. The builder SHOULD be directly used as package input, not by overriding `buildGoModule` in all-packages.nix, to make this dependency explicit.

5. Go toolchains MUST be removed soon after they reach end of life, latest with the next security update that won't target them anymore.

    When an end-of-life toolchain is removed, builders that pin the EOL version (according to 3.) will automatically be bumped to the then oldest pinned builder (e.g. Go 1.22 is EOL, `buildGo122Module` is bumped to `buildGo123Module`).

    If the package won't build with anymore with that builder, the package is marked broken.
    It is the package maintainers responsibility to fix the package and get it working with a supported Go toolchain.

[1]: http://go.dev/doc/go1compat
