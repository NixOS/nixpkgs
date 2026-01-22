## Go toolchain/builder upgrade policy

Go promises that "programs written to the Go 1 specification will continue to compile and run correctly, unchanged, over the lifetime of that specification" [1].
Newer toolchain versions should build projects developed against older toolchains without problems.

**Definition(a "toolchain-breaking" package):**
There are however Go packages depending on internal APIs of the toolchain/runtime/stdlib that are not covered by the Go compatibility promise.
These packages may break on toolchain minor version upgrades.

**Definition(a "toolchain-latest" package):**
Packages providing development support for the Go language (like `gopls`, `golangci-lint`,...) depend on the toolchain in another way: they must be compiled at least with the version they should be used for.
If `gopls` is compiled for Go 1.23, it won't work for projects that require Go 1.24.

Go only ever has two supported toolchains. With a new minor release, the second last Go toolchain is automatically end of life, meaning it won't receive security updates anymore.

Based on this, we align on the following policy for toolchain/builder upgrades for the unstable release:

1. Default toolchain (the `go` package) and builder (`buildGoModule`) are upgraded to the latest minor release of Go as soon as it is released.
  As it is a mass rebuild, this package will be made against the `staging` branch.

2. The `go_latest` toolchain and the `buildGoLatestModule` are also bumped directly after release, but the update goes to the `master` branch.

    Packages in `toolchain-latest` SHOULD use `go_latest`/`buildGoLatestModule`.
    Packages in nixpkgs MUST only use this toolchain/builder if they have a good reason to do so
    A comment MUST be added explaining why this is the case for a certain package.
    It is important to keep the number of packages using this builder within nixpkgs low, so the bump won't cause a mass rebuild.

    `go_latest` MUST not point to release candidates of Go.

    Consumer outside of nixpkgs on the other hand MAY rely on this toolchain/builder if they prefer being upgraded earlier to the newest toolchain minor version.

3. Packages in `toolchain-breaking` SHOULD pin a toolchain version by using a builder with a fixed Go version (`buildGo1xxModule`).
  The use of `buildGo1xxModule` MUST be accompanied with a comment explaining why this has a dependency on a specific Go version.
  The comment should target the Go team in nixpkgs and ease their work in case they have to touch the package (see 5.).

4. The builder SHOULD be directly used as package input, not by overriding `buildGoModule` in all-packages.nix, to make this dependency explicit.

5. Go toolchains MUST be removed soon after they reach end of life, latest with the next security update that won't target them anymore.

    When an end-of-life toolchain is removed, builders that pin the EOL version (according to 3.) will automatically be bumped to the then oldest pinned builder (e.g. Go 1.22 is EOL, `buildGo122Module` is bumped to `buildGo123Module`).

    If the package won't build with that builder anymore, the package is marked broken.
    It is the package maintainers responsibility to fix the package and get it working with a supported Go toolchain.

For the stable release, we recognize that (1) removing a Go version, or updating the `go_latest` or `go` packages to a new Go minor release, would be a breaking change, and (2) some packages will need backports (e.g. for security reasons) that require the latest Go version.
Therefore, on the stable release, new Go versions will be backported to the `release-2x.xx` branch, but the old versions will remain, and `go`, `buildGoModule`, `go_latest`, and `buildGoLatestModule` will remain unchanged.
However, `rc` versions should not be backported to the stable branch.

[1]: http://go.dev/doc/go1compat
