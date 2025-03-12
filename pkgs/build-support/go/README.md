## Go toolchain/builder upgrade policy

Go promises that "programs written to the Go 1 specification will continue to compile and run correctly, unchanged, over the lifetime of that specification" [1].
Newer toolchain versions should build projects developed against older toolchains without problems.

There are however Go packages depending on internal APIs of the toolchain/runtime/stdlib that is not covered by the Go compatibility promise.
These packages may break on toolchain updates.
We name the set of these packages `toolchain-breaking`.

There is another set of packages that depends on the toolchain, but in another way:
Packages providing development support for the Go language (like `gopls`, `golangci-lint`,...) must be compiled with the version they should be used for.
If `gopls` is compiled for Go 1.23, it won't work for projects that require Go 1.24.
We name the set of these packages `toolchain-latest`.

Go only ever has two supported toolchains. With a new minor release, the second last Go toolchain is automatically end of life, meaning it won't receive security updates anymore.

Based on this, we align on the following policy for toolchain/builder upgrades:

1. Toolchain (the `go` package) and builder (`buildGoModule`) are upgraded to the latest minor release of Go as soon as it is released.

2. Packages in `toolchain-latest` SHOULD NOT pin a toolchain version.
   They automatically receive the new toolchain version after the bump from 1. went through staging.

3. Packages in `toolchain-breaking` SHOULD pin a toolchain version by using a builder with a fixed Go version (`buildGo1XXModule`).
   The builder SHOULD be directly used as package input, not by overriding `buildGoModule` in all-packages.nix, to make this dependency explicit.
   The use of `buildGo1XXModule` SHOULD be accompanied with a comment about why this has a dependency on a specific Go version.
   The comment should target the Go team in nixpkgs and ease their work in case they have to touch the package.

4. Go toolchains MUST be removed soon after they reach end of life, latest with the next security update that won't target them anymore.

    When an end-of-life toolchain is removed, builders that pin the EOL version will automatically be bumped to the then oldest pinned builder (e.g. Go 1.22 is EOL, `buildGo122Module` is bumped to `buildGo123Module`).
    If the package won't build with anymore with that builder, the package is marked broken.

[1]: http://go.dev/doc/go1compat


### Alternatives considered

1. Introducing a `go_latest`/`buildGoLatestModule`: These would be bumped immediately after a minor release.
   The bump of `go`/`buildGoModule` could happen later.
   This would solve the problem with the packages requiring the latest toolchain and packages could explicitly depend on the latest version.
   However, it would require additional work, as we keep the separation into three different types of package requirements, whereas the solution above only differentiate two requirements (as packages requiring latest and packages without specific toolchain requirements are handled together).
