# Platform Support {#chap-platform-support}

Packages receive varying degrees of support, both in terms of maintainer attention and available computation resources for continuous integration (CI). We have 7 defined tiers denoting how well supported each platform is.

## Tiers {#sec-platform-tiers}

### Tier 1 {#sec-platform-tier1}

[Tier 1](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-1) platforms receive the highest level of support where problems can block updates, platform-specific patches are freely applied, and most packages are expected to work.

### Tier 2 {#sec-platform-tier2}

[Tier 2](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-2) platforms are expected to remain functional with updates, receive platform-specific patches as needed, and have many packages built by Hydra with full ofBorg support.

### Tier 3 {#sec-platform-tier3}

[Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) platforms may receive non-intrusive platform-specific fixes, have native bootstrap tools available with cross-build toolchains in binary cache, but updates might break builds on these platforms.

### Tier 4-7 {#sec-platform-tier4-7}

Platform Tiers [4 through 7](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-4) indicate varying levels of minimal support going from receiving only limited fixes to platforms with no support, but a path to support.

## Breakdown {#sec-platform-breakdown}

| Triple                        | Support Tier | Channel Blockers | Hydra Support | Ofborg Support | Bootstrap Tarballs | Cross Compiling Support |
| ----------------------------- | ------------ | ---------------- | ------------- | -------------- | ------------------ | ----------------------- |
| `aarch64-apple-darwin`        | [Tier 2](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-2) | Some | ✔️            | ✔️             | ✔️                 | ❌                      |
| `aarch64-linux-gnu`           | [Tier 2](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-2) | Some | ✔️            | ✔️             | ✔️                 | ✔️                      |
| `aarch64-linux-musl`          | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `armv5tel-linux-gnueabi`      | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `armv6l-linux-gnueabihf`      | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `armv6l-linux-musleabihf`     | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `armv7l-linux-gnueabihf`      | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `i686-linux-gnu`              | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `loongarch64-linux-gnu`       | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `mips64el-linux-gnuabi64`     | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `mips64el-linux-gnuabin32`    | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `mipsel-linux-gnu`            | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `powerpc64-linux-gnuabielfv2` | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `powerpc64le-linux-gnu`       | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `riscv32-linux-gnu`           | [Tier 4](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-4) | None | ❌            | ❌             | ❌                 | ✔️                      |
| `riscv64-linux-gnu`           | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `s390x-linux-gnu`             | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `x86_64-apple-darwin`         | [Tier 2](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-2) | Some | ✔️            | ✔️             | ✔️                 | ❌                      |
| `x86_64-linux-gnu`            | [Tier 1](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-1) | Many | ✔️            | ✔️             | ✔️                 | ✔️                      |
| `x86_64-linux-musl`           | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
| `x86_64-unknown-freebsd`      | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌            | ❌             | ✔️                 | ✔️                      |
