# Bootstrap files

Currently `nixpkgs` builds most of its packages using bootstrap seed binaries (without the reliance on external inputs):

- `bootstrap-tools`: an archive with the compiler toolchain and other helper tools enough to build the rest of the `nixpkgs`.
- initial binaries needed to unpack `bootstrap-tools.*`.
  On `linux` it's just `busybox`, on `darwin` and `freebsd` it is unpack.nar.xz which contains the binaries and script needed to unpack the tools.
  These binaries can be executed directly from the store.

These are called "bootstrap files".

Bootstrap files should always be fetched from hydra and uploaded to `tarballs.nixos.org` to guarantee that all the binaries were built from the code committed into `nixpkgs` repository.

The uploads to `tarballs.nixos.org` are done by `@lovesegfault` today.

This document describes the procedure of updating bootstrap files in `nixpkgs`.

## How to request the bootstrap seed update

To get the tarballs updated let's use an example `i686-unknown-linux-gnu` target:

1. Create a local update:

   ```
   $ maintainers/scripts/bootstrap-files/refresh-tarballs.bash --commit --targets=i686-unknown-linux-gnu
   ```

2. Test the update locally. I'll build local `hello` derivation with the result:

   ```
   $ nix-build -A hello --argstr system i686-linux
   ```

   To validate cross-targets `binfmt` `NixOS` helper can be useful.
   For `riscv64-unknown-linux-gnu` the `/etc/nixos/configuration.nix` entry would be `boot.binfmt.emulatedSystems = [ "riscv64-linux" ]`.

3. Propose the commit as a PR to update bootstrap tarballs, tag people who can help you test the updated architecture and once reviewed tag `@lovesegfault` to upload the tarballs.

## How to add bootstrap files for a new target

The procedure to add a new target is very similar to the update procedure.
The only difference is that you need to set up a new job to build the `bootstrapFiles`.
To do that you will need the following:

1. Add your new target to `lib/systems/examples.nix`

   This will populate `pkgsCross.$target` attribute set.
   If you are dealing with `bootstrapFiles` upload you probably already have it.

2. Add your new target to `pkgs/stdenv/linux/make-bootstrap-tools-cross.nix`.
   This will add a new hydra job to `nixpkgs:cross-trunk` jobset.

3. Wait for a hydra to build your bootstrap tarballs.

4. Add your new target to `maintainers/scripts/bootstrap-files/refresh-tarballs.bash` around `CROSS_TARGETS=()`.

5. Add your new target to `pkgs/stdenv/linux/default.nix` and follow standard bootstrap seed update procedure above.

## Bootstrap files job definitions

There are two types of bootstrap files:

- natively built `stdenvBootstrapTools.build` hydra jobs in [`nixpkgs:trunk`](https://hydra.nixos.org/jobset/nixpkgs/trunk#tabs-jobs) jobset.
  Incomplete list of examples is:

  * `aarch64-unknown-linux-musl.nix`
  * `i686-unknown-linux-gnu.nix`

  These are Tier 1 hydra platforms.

- cross-built by `bootstrapTools.build` hydra jobs in [`nixpkgs:cross-trunk`](https://hydra.nixos.org/jobset/nixpkgs/cross-trunk#tabs-jobs) jobset.
  Incomplete list of examples is:

  * `mips64el-unknown-linux-gnuabi64.nix`
  * `mips64el-unknown-linux-gnuabin32.nix`
  * `mipsel-unknown-linux-gnu.nix`
  * `powerpc64le-unknown-linux-gnu.nix`
  * `riscv64-unknown-linux-gnu.nix`

  These are usually Tier 2 and lower targets.

The `.build` job contains `/on-server/` subdirectory with binaries to be uploaded to `tarballs.nixos.org`.
The files are uploaded to `tarballs.nixos.org` by writers to `S3` store.
