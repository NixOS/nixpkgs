# Platform Support {#chap-platform-support}

Packages receive varying degrees of support, both in terms of maintainer attention and available computation resources for continuous integration (CI). We have 4 defined tiers denoting how well supported each platform is. If a platform is not listed, it is likely nixpkgs will not support it any time soon or there may not be any work towards supporting it.

## Tiers {#sec-platform-tiers}

### Tier 1 {#sec-platform-tier1}

Tier 1 is the most supported tier, it indiciated that the platform is well supported and utilized. You can expect the targets to be stable between every release. Below is the list of tier 1 platforms:

- `x86_64-linux`

### Tier 2 {#sec-platform-tier2}

Tier 2 contains targets which aren't guranteed to be stable like in tier 1. However, these platforms have somewhat of an effort to be supported. Below is the list of tier 2 platforms:

- `aarch64-apple-darwin`
- `aarch64-linux-gnu`
- `x86_64-apple-darwin`

### Tier 3 {#sec-platform-tier3}

Tier 3 platforms are targets which aren't largely support but a good set of packages can build. These targets are not built on Hydra so there is no official public cache. However, it is possible to bootstrap these platforms and cross compile. Below is the list of tier 3 platforms:

- `aarch64-linux-musl`
- `armv5tel-linux-gnueabi`
- `armv6-linux-musleabihf`
- `armv7l-linux-gnueabihf`
- `i686-linux-gnu`
- `loongarch64-linux-gnu`
- `mips64el-linux-gnuabi64`
- `mips64el-linux-gnuabin32`
- `mipsel-linux-gnu`
- `powerpc64-linux-gnuabielfv2`
- `powerpc64le-linux-gnu`
- `riscv64-linux-gnu`
- `s390x-linux-gnu`
- `x86_64-linux-musl`
- `x86_64-unknown-freebsd`

### Tier 4 {#sec-platform-tier4}

Tier 4 platforms are targets with little support but are known. These platforms may cross compile but are not supported with bootstrapping. Like tier 3, there is no public cache due to Hydra not building these systems. Below is the list of tier 4 platforms:

- `riscv32-linux-gnu`

## Breakdown {#sec-platform-breakdown}

| Triple                        | User Adoption | Hydra Support | Ofborg Support | Bootstrap Tarballs | Cross Compiling Support |
| ----------------------------- | ------------- | ------------- | -------------- | ------------------ | ----------------------- |
| `aarch64-apple-darwin`        | ✔️            | ✔️            | ✔️             | ✔️                 | ❌                      |
| `aarch64-linux-gnu`           | ❌            | ✔️            | ✔️             | ✔️                 | ✔️                      |
| `aarch64-linux-musl`          | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `armv5tel-linux-gnueabi`      | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `armv6l-linux-gnueabihf`      | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `armv6l-linux-musleabihf`     | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `armv7l-linux-gnueabihf`      | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `i686-linux-gnu`              | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `loongarch64-linux-gnu`       | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `mips64el-linux-gnuabi64`     | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `mips64el-linux-gnuabin32`    | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `mipsel-linux-gnu`            | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `powerpc64-linux-gnuabielfv2` | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `powerpc64le-linux-gnu`       | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `riscv32-linux-gnu`           | ❌            | ❌            | ❌             | ❌                 | ✔️                      |
| `riscv64-linux-gnu`           | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `s390x-linux-gnu`             | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `x86_64-apple-darwin`         | ✔️            | ✔️            | ✔️             | ✔️                 | ❌                      |
| `x86_64-linux-gnu`            | ✔️            | ✔️            | ✔️             | ✔️                 | ✔️                      |
| `x86_64-linux-musl`           | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
| `x86_64-unknown-freebsd`      | ❌            | ❌            | ❌             | ✔️                 | ✔️                      |
