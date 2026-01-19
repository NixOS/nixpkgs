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

| Triple                                | Support Tier | Channel Blockers | Hydra Support | Ofborg Support | Bootstrap Tarballs | Cross Compiling Support |
| ------------------------------------- | ------------ | ---------------- | ------------- | -------------- | ------------------ | ----------------------- |
| `x86_64-unknown-linux-gnu`            | [Tier 1](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-1) | Many | ✔️            | ✔️            | ✔️                 | ✔️                      |
| `aarch64-unknown-linux-gnu`           | [Tier 2](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-2) | Some | ✔️            | ✔️            | ✔️                 | ✔️                      |
| `x86_64-unknown-linux-musl`           | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | Limited        | ❌             | ✔️                 | ✔️                      |
| `aarch64-unknown-linux-musl`          | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | Limited        | ❌             | ✔️                 | ✔️                      |
| `x86_64-unknown-unknown-freebsd`      | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `arm64-apple-darwin`                  | [Tier 2](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-2) | Some | ✔️            | ✔️            | ✔️                 | ❌\*                     |
| `x86_64-apple-darwin`                 | [Tier 2](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-2) | Some | ✔️            | ✔️            | ✔️                 | ❌\*                     |
| `i686-unknown-linux-gnu`              | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | Limited        | ❌             | ✔️                 | ✔️                      |
| `riscv32-unknown-linux-gnu`           | [Tier 4](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-4) | None | ❌             | ❌             | ❌                  | ✔️                      |
| `riscv64-unknown-linux-gnu`           | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `loongarch64-unknown-linux-gnu`       | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `armv6l-unknown-linux-gnueabihf`      | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `armv6l-unknown-linux-musleabihf`     | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `armv7l-unknown-linux-gnueabihf`      | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `armv5tel-unknown-linux-gnueabi`      | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `mips64el-unknown-linux-gnuabi64`     | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `mips64el-unknown-linux-gnuabin32`    | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `mipsel-unknown-linux-gnu`            | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `powerpc64-unknown-linux-gnuabielfv2` | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `powerpc64le-unknown-linux-gnu`       | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |
| `s390x-unknown-linux-gnu`             | [Tier 3](https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#tier-3) | None | ❌             | ❌             | ✔️                 | ✔️                      |

\* - Cross compiling is only supported on Darwin hosts.
