# Platform Support Tiers {#platform-support-tiers}

In the context of Nixpkgs, a *platform* can mean a CPU architecture, a
[cross-compilation](#chap-cross) target or a C library option.

Nixpkgs defines 7 platform *support tiers*, meaning levels of support for each platform.

**TODO**: change build successfully to a definition of "work".

## Tier 1 {#platform-support-tier-1}

These platforms receive the highest level of support, meaning that every
platform-compatible package in Nixpkgs must successfully build in the Hydra and OfBorg CIs.
**TODO**: this seems to not be entirely true for Hydra, but true for OfBorg.

- `x86_64-linux`, `gcc` + `glibc`

## Tier 2 {#platform-support-tier-2}

Many of the packages are required to build successfully on these platforms in CI, the rest are supported on a best-effort basis by dedicated platform maintainers.
**TODO**: link teams

- `aarch64-linux`, `gcc+glibc`
- `x86_64-darwin`, `clang+Darwin/macOS`

## Tier 3 {#platform-support-tier-3}

None of the packages for these platforms are required to build successfully in
CI, but it is expected that most of them will build successfully.

- `i686-linux`, `gcc`+`glibc`
- `armv{6,7,8}*-linux`, `gcc`+`glibc`
- `armv{6,7,8}*-linux`, `gcc`+`glibc`, cross-compilation
- `aarch64-linux`, `gcc`+`glibc`, cross-compilation
- `mipsel-linux`, `gcc`+`glibc`
- `x86_64-linux`, `gcc`+`musl`

## Tier 4 {#platform-support-tier-4}

Some of the packages for these platforms are expected to work. The
[`exotic-platform-maintainers`
Team](https://github.com/orgs/NixOS/teams/exotic-platform-maintainers) is
responsible for this platform.

- `aarch64-none`
- `avr`
- `arm-none`
- `i686-none`
- `x86_64-none`
- `powerpc-none`
- `powerpcle-none`
- `x86_64-mingw32`
- `i686-mingw32`
- `x86_64-linux`, `gcc`+`musl` — static
- `x86_64-linux`, `clang`+`glibc`
- `x86_64-linux`, `clang`+`glibc` — `llvm` linker
- `x86_64-linux` — Android
- `aarch64-linux` — Android
- `armv{7,8}-linux` — Android

## Tier 5 {#platform-support-tier-5}

A small number of packages might build successfully on these platforms.

- `x86_64-linux`, `gcc`+`glibc` — static
- `x86_64-linux`, `gcc`+`glibc` — `llvm` linker

## Tier 6 {#platform-support-tier-6}

These platforms are defined in Nixpkgs, but no packages are expected to build on them.

- `wasm-wasi`
- `powerpc64le-linux`, `gcc`+`glibc`

## Tier 7 {#platform-support-tier-7}

No current support, but previous support or clear path to add support.

- `aarch64-darwin`
- `i686-darwin`
- `x86_64-freebsd`
- `i686-solaris`
- `x86_64-illumos`

## Further reading {#platform-support-tiers-further-reading}

For a formal definition of platform support tiers, see [RFC046](https://github.com/7c6f434c/rfcs/blob/platform-support-tiers/rfcs/0046-platform-support-tiers.md).
