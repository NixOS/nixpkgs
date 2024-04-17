# Bootstrap files

Currently `nixpkgs` builds most of it's packages using bootstrap seed
binaries (without the reliance on external inputs):

- `bootstrap-tools`: an archive with the compiler toolchain and other
  helper tools enough to build the rest of the `nixpkgs`.
- initial binaries needed to unpack `bootstrap-tools.*`. On `linux`
  it's just `busybox`, on `darwin` it is unpack.nar.xz which contains
  the binaries and script needed to unpack the tools. These binaries
  can be executed directly from the store.

These are called "bootstrap files".

Bootstrap files should always be fetched from hydra and uploaded to
`tarballs.nixos.org` to guarantee that all the binaries were built from
the code committed into `nixpkgs` repository.

The uploads to `tarballs.nixos.org` are done by `@lovesegfault` today.

This document describes the procedure of updating bootstrap files in
`nixpkgs`.

## How to request the bootstrap seed update

To get the tarballs updated let's use an example `i686-unknown-linux-gnu`
target:

1. Create a local update:

   ```
   $ maintainers/scripts/bootstrap-files/refresh-tarballs.bash --commit --targets=i686-unknown-linux-gnu
   ```

2. Test the update locally. I'll build local `hello` derivation with
   the result:

   ```
   $ nix-build -A hello --argstr system i686-linux
   ```

   To validate cross-targets `binfmt` `NixOS` helper can be useful.
   For `riscv64-unknown-linux-gnu` the `/etc/nixos/configuration.nix`
   entry would be `boot.binfmt.emulatedSystems = [ "riscv64-linux" ]`.

3. Propose the commit as a PR to update bootstrap tarballs, tag people
   who can help you test the updated architecture and once reviewed tag
  `@lovesegfault` to upload the tarballs.

## Bootstrap files job definitions

There are two types of bootstrap files:

- natively built `stdenvBootstrapTools.build` hydra jobs in
  [`nixpkgs:trunk`](https://hydra.nixos.org/jobset/nixpkgs/trunk#tabs-jobs)
  jobset. Incomplete list of examples is:

  * `aarch64-unknown-linux-musl.nix`
  * `i686-unknown-linux-gnu.nix`

  These are Tier 1 hydra platforms.

- cross-built by `bootstrapTools.build` hydra jobs in
  [`nixpkgs:cross-trunk`](https://hydra.nixos.org/jobset/nixpkgs/cross-trunk#tabs-jobs)
  jobset. Incomplete list of examples is:

  * `mips64el-unknown-linux-gnuabi64.nix`
  * `mips64el-unknown-linux-gnuabin32.nix`
  * `mipsel-unknown-linux-gnu.nix`
  * `powerpc64le-unknown-linux-gnu.nix`
  * `riscv64-unknown-linux-gnu.nix`

  These are usually Tier 2 and lower targets.

The `.build` job contains `/on-server/` subdirectory with binaries to
be uploaded to `tarballs.nixos.org`.
The files are uploaded to `tarballs.nixos.org` by writers to `S3` store.
