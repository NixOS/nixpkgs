# Rust {#rust}

To install the rust compiler and cargo put

```nix
environment.systemPackages = [
  rustc
  cargo
];
```

into your `configuration.nix` or bring them into scope with `nix-shell -p rustc cargo`.

For other versions such as daily builds (beta and nightly),
use either `rustup` from nixpkgs (which will manage the rust installation in your home directory),
or use [community maintained Rust toolchains](#using-community-maintained-rust-toolchains).

## `buildRustPackage`: Compiling Rust applications with Cargo {#compiling-rust-applications-with-cargo}

Rust applications are packaged by using the `buildRustPackage` helper from `rustPlatform`:

```nix
{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "12.1.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    hash = "sha256-+s5RBC3XSgb8omTbUNLywZnP6jSxZBKSS1BmXOjRF8M=";
  };

  cargoHash = "sha256-jtBw4ahSl88L0iuCXxQgZVm1EcboWRJMNtjxLVTtzts=";

  meta = with lib; {
    description = "A fast line-oriented regex search tool, similar to ag and ack";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = licenses.unlicense;
    maintainers = [];
  };
}
```

`buildRustPackage` requires either the `cargoSha256` or the
`cargoHash` attribute which is computed over all crate sources of this
package. `cargoHash256` is used for traditional Nix SHA-256 hashes,
such as the one in the example above. `cargoHash` should instead be
used for [SRI](https://www.w3.org/TR/SRI/) hashes. For example:

Exception: If the application has cargo `git` dependencies, the `cargoHash`/`cargoSha256`
approach will not work, and you will need to copy the `Cargo.lock` file of the application
to nixpkgs and continue with the next section for specifying the options of the`cargoLock`
section.

```nix
  cargoHash = "sha256-l1vL2ZdtDRxSGvP0X/l3nMw8+6WF67KPutJEzUROjg8=";
```

Both types of hashes are permitted when contributing to nixpkgs. The
Cargo hash is obtained by inserting a fake checksum into the
expression and building the package once. The correct checksum can
then be taken from the failed build. A fake hash can be used for
`cargoSha256` as follows:

```nix
  cargoSha256 = lib.fakeSha256;
```

For `cargoHash` you can use:

```nix
  cargoHash = lib.fakeHash;
```

Per the instructions in the [Cargo Book](https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html)
best practices guide, Rust applications should always commit the `Cargo.lock`
file in git to ensure a reproducible build. However, a few packages do not, and
Nix depends on this file, so if it is missing you can use `cargoPatches` to
apply it in the `patchPhase`. Consider sending a PR upstream with a note to the
maintainer describing why it's important to include in the application.

The fetcher will verify that the `Cargo.lock` file is in sync with the `src`
attribute, and fail the build if not. It will also will compress the vendor
directory into a tar.gz archive.

The tarball with vendored dependencies contains a directory with the
package's `name`, which is normally composed of `pname` and
`version`. This means that the vendored dependencies hash
(`cargoSha256`/`cargoHash`) is dependent on the package name and
version. The `cargoDepsName` attribute can be used to use another name
for the directory of vendored dependencies. For example, the hash can
be made invariant to the version by setting `cargoDepsName` to
`pname`:

```nix
rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-aDQA4A5mScX9or3Lyiv/5GyAehidnpKKE0grhbP1Ctc=";
  };

  cargoHash = "sha256-tbrTbutUs5aPSV+yE0IBUZAAytgmZV7Eqxia7g+9zRs=";
  cargoDepsName = pname;

  # ...
}
```

### Importing a `Cargo.lock` file {#importing-a-cargo.lock-file}

Using `cargoSha256` or `cargoHash` is tedious when using
`buildRustPackage` within a project, since it requires that the hash
is updated after every change to `Cargo.lock`. Therefore,
`buildRustPackage` also supports vendoring dependencies directly from
a `Cargo.lock` file using the `cargoLock` argument. For example:

```nix
rustPlatform.buildRustPackage {
  pname = "myproject";
  version = "1.0.0";

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  # ...
}
```

This will retrieve the dependencies using fixed-output derivations from
the specified lockfile.

One caveat is that `Cargo.lock` cannot be patched in the `patchPhase`
because it runs after the dependencies have already been fetched. If
you need to patch or generate the lockfile you can alternatively set
`cargoLock.lockFileContents` to a string of its contents:

```nix
rustPlatform.buildRustPackage {
  pname = "myproject";
  version = "1.0.0";

  cargoLock = let
    fixupLockFile = path: f (builtins.readFile path);
  in {
    lockFileContents = fixupLockFile ./Cargo.lock;
  };

  # ...
}
```

Note that setting `cargoLock.lockFile` or `cargoLock.lockFileContents`
doesn't add a `Cargo.lock` to your `src`, and a `Cargo.lock` is still
required to build a rust package. A simple fix is to use:

```nix
postPatch = ''
  ln -s ${./Cargo.lock} Cargo.lock
'';
```

The output hash of each dependency that uses a git source must be
specified in the `outputHashes` attribute. For example:

```nix
rustPlatform.buildRustPackage rec {
  pname = "myproject";
  version = "1.0.0";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "finalfusion-0.14.0" = "17f4bsdzpcshwh74w5z119xjy2if6l2wgyjy56v621skr2r8y904";
    };
  };

  # ...
}
```

If you do not specify an output hash for a git dependency, building
the package will fail and inform you of which crate needs to be
added. To find the correct hash, you can first use `lib.fakeSha256` or
`lib.fakeHash` as a stub hash. Building the package (and thus the
vendored dependencies) will then inform you of the correct hash.

For usage outside nixpkgs, `allowBuiltinFetchGit` could be used to
avoid having to specify `outputHashes`. For example:

```nix
rustPlatform.buildRustPackage rec {
  pname = "myproject";
  version = "1.0.0";

  cargoLock = {
    lockFile = ./Cargo.lock;
    allowBuiltinFetchGit = true;
  };

  # ...
}
```

### Cargo features {#cargo-features}

You can disable default features using `buildNoDefaultFeatures`, and
extra features can be added with `buildFeatures`.

If you want to use different features for check phase, you can use
`checkNoDefaultFeatures` and `checkFeatures`. They are only passed to
`cargo test` and not `cargo build`. If left unset, they default to
`buildNoDefaultFeatures` and `buildFeatures`.

For example:

```nix
rustPlatform.buildRustPackage rec {
  pname = "myproject";
  version = "1.0.0";

  buildNoDefaultFeatures = true;
  buildFeatures = [ "color" "net" ];

  # disable network features in tests
  checkFeatures = [ "color" ];

  # ...
}
```

### Cross compilation {#cross-compilation}

By default, Rust packages are compiled for the host platform, just like any
other package is.  The `--target` passed to rust tools is computed from this.
By default, it takes the `stdenv.hostPlatform.config` and replaces components
where they are known to differ. But there are ways to customize the argument:

 - To choose a different target by name, define
   `stdenv.hostPlatform.rustc.config` as that name (a string), and that
   name will be used instead.

   For example:

   ```nix
   import <nixpkgs> {
     crossSystem = (import <nixpkgs/lib>).systems.examples.armhf-embedded // {
       rustc.config = "thumbv7em-none-eabi";
     };
   }
   ```

   will result in:

   ```shell
   --target thumbv7em-none-eabi
   ```

 - To pass a completely custom target, define
   `stdenv.hostPlatform.rustc.config` with its name, and
   `stdenv.hostPlatform.rustc.platform` with the value.  The value will be
   serialized to JSON in a file called
   `${stdenv.hostPlatform.rustc.config}.json`, and the path of that file
   will be used instead.

   For example:

   ```nix
   import <nixpkgs> {
     crossSystem = (import <nixpkgs/lib>).systems.examples.armhf-embedded // {
       rustc.config = "thumb-crazy";
       rustc.platform = { foo = ""; bar = ""; };
     };
   }
   ```

   will result in:

   ```shell
   --target /nix/store/asdfasdfsadf-thumb-crazy.json # contains {"foo":"","bar":""}
   ```

Note that currently custom targets aren't compiled with `std`, so `cargo test`
will fail. This can be ignored by adding `doCheck = false;` to your derivation.

### Running package tests {#running-package-tests}

When using `buildRustPackage`, the `checkPhase` is enabled by default and runs
`cargo test` on the package to build. To make sure that we don't compile the
sources twice and to actually test the artifacts that will be used at runtime,
the tests will be ran in the `release` mode by default.

However, in some cases the test-suite of a package doesn't work properly in the
`release` mode. For these situations, the mode for `checkPhase` can be changed like
so:

```nix
rustPlatform.buildRustPackage {
  /* ... */
  checkType = "debug";
}
```

Please note that the code will be compiled twice here: once in `release` mode
for the `buildPhase`, and again in `debug` mode for the `checkPhase`.

Test flags, e.g., `--package foo`, can be passed to `cargo test` via the
`cargoTestFlags` attribute.

Another attribute, called `checkFlags`, is used to pass arguments to the test
binary itself, as stated
[here](https://doc.rust-lang.org/cargo/commands/cargo-test.html).

#### Tests relying on the structure of the `target/` directory {#tests-relying-on-the-structure-of-the-target-directory}

Some tests may rely on the structure of the `target/` directory. Those tests
are likely to fail because we use `cargo --target` during the build. This means that
the artifacts
[are stored in `target/<architecture>/release/`](https://doc.rust-lang.org/cargo/guide/build-cache.html),
rather than in `target/release/`.

This can only be worked around by patching the affected tests accordingly.

#### Disabling package-tests {#disabling-package-tests}

In some instances, it may be necessary to disable testing altogether (with `doCheck = false;`):

* If no tests exist -- the `checkPhase` should be explicitly disabled to skip
  unnecessary build steps to speed up the build.
* If tests are highly impure (e.g. due to network usage).

There will obviously be some corner-cases not listed above where it's sensible to disable tests.
The above are just guidelines, and exceptions may be granted on a case-by-case basis.

However, please check if it's possible to disable a problematic subset of the
test suite and leave a comment explaining your reasoning.

This can be achieved with `--skip` in `checkFlags`:

```nix
rustPlatform.buildRustPackage {
  /* ... */
  checkFlags = [
    # reason for disabling test
    "--skip=example::tests:example_test"
  ];
}
```

#### Using `cargo-nextest` {#using-cargo-nextest}

Tests can be run with [cargo-nextest](https://github.com/nextest-rs/nextest)
by setting `useNextest = true`. The same options still apply, but nextest
accepts a different set of arguments and the settings might need to be
adapted to be compatible with cargo-nextest.

```nix
rustPlatform.buildRustPackage {
  /* ... */
  useNextest = true;
}
```

#### Setting `test-threads` {#setting-test-threads}

`buildRustPackage` will use parallel test threads by default,
sometimes it may be necessary to disable this so the tests run consecutively.

```nix
rustPlatform.buildRustPackage {
  /* ... */
  dontUseCargoParallelTests = true;
}
```

### Building a package in `debug` mode {#building-a-package-in-debug-mode}

By default, `buildRustPackage` will use `release` mode for builds. If a package
should be built in `debug` mode, it can be configured like so:

```nix
rustPlatform.buildRustPackage {
  /* ... */
  buildType = "debug";
}
```

In this scenario, the `checkPhase` will be ran in `debug` mode as well.

### Custom `build`/`install`-procedures {#custom-buildinstall-procedures}

Some packages may use custom scripts for building/installing, e.g. with a `Makefile`.
In these cases, it's recommended to override the `buildPhase`/`installPhase`/`checkPhase`.

Otherwise, some steps may fail because of the modified directory structure of `target/`.

### Building a crate with an absent or out-of-date Cargo.lock file {#building-a-crate-with-an-absent-or-out-of-date-cargo.lock-file}

`buildRustPackage` needs a `Cargo.lock` file to get all dependencies in the
source code in a reproducible way. If it is missing or out-of-date one can use
the `cargoPatches` attribute to update or add it.

```nix
rustPlatform.buildRustPackage rec {
  (...)
  cargoPatches = [
    # a patch file to add/update Cargo.lock in the source code
    ./add-Cargo.lock.patch
  ];
}
```

### Compiling non-Rust packages that include Rust code {#compiling-non-rust-packages-that-include-rust-code}

Several non-Rust packages incorporate Rust code for performance- or
security-sensitive parts. `rustPlatform` exposes several functions and
hooks that can be used to integrate Cargo in non-Rust packages.

#### Vendoring of dependencies {#vendoring-of-dependencies}

Since network access is not allowed in sandboxed builds, Rust crate
dependencies need to be retrieved using a fetcher. `rustPlatform`
provides the `fetchCargoTarball` fetcher, which vendors all
dependencies of a crate. For example, given a source path `src`
containing `Cargo.toml` and `Cargo.lock`, `fetchCargoTarball`
can be used as follows:

```nix
cargoDeps = rustPlatform.fetchCargoTarball {
  inherit src;
  hash = "sha256-BoHIN/519Top1NUBjpB/oEMqi86Omt3zTQcXFWqrek0=";
};
```

The `src` attribute is required, as well as a hash specified through
one of the `hash` attribute. The following optional attributes can
also be used:

* `name`: the name that is used for the dependencies tarball.  If
  `name` is not specified, then the name `cargo-deps` will be used.
* `sourceRoot`: when the `Cargo.lock`/`Cargo.toml` are in a
  subdirectory, `sourceRoot` specifies the relative path to these
  files.
* `patches`: patches to apply before vendoring. This is useful when
  the `Cargo.lock`/`Cargo.toml` files need to be patched before
  vendoring.

If a `Cargo.lock` file is available, you can alternatively use the
`importCargoLock` function. In contrast to `fetchCargoTarball`, this
function does not require a hash (unless git dependencies are used)
and fetches every dependency as a separate fixed-output derivation.
`importCargoLock` can be used as follows:

```
cargoDeps = rustPlatform.importCargoLock {
  lockFile = ./Cargo.lock;
};
```

If the `Cargo.lock` file includes git dependencies, then their output
hashes need to be specified since they are not available through the
lock file. For example:

```
cargoDeps = rustPlatform.importCargoLock {
  lockFile = ./Cargo.lock;
  outputHashes = {
    "rand-0.8.3" = "0ya2hia3cn31qa8894s3av2s8j5bjwb6yq92k0jsnlx7jid0jwqa";
  };
};
```

If you do not specify an output hash for a git dependency, building
`cargoDeps` will fail and inform you of which crate needs to be
added. To find the correct hash, you can first use `lib.fakeSha256` or
`lib.fakeHash` as a stub hash. Building `cargoDeps` will then inform
you of the correct hash.

#### Hooks {#hooks}

`rustPlatform` provides the following hooks to automate Cargo builds:

* `cargoSetupHook`: configure Cargo to use dependencies vendored
  through `fetchCargoTarball`. This hook uses the `cargoDeps`
  environment variable to find the vendored dependencies. If a project
  already vendors its dependencies, the variable `cargoVendorDir` can
  be used instead. When the `Cargo.toml`/`Cargo.lock` files are not in
  `sourceRoot`, then the optional `cargoRoot` is used to specify the
  Cargo root directory relative to `sourceRoot`.
* `cargoBuildHook`: use Cargo to build a crate. If the crate to be
  built is a crate in e.g. a Cargo workspace, the relative path to the
  crate to build can be set through the optional `buildAndTestSubdir`
  environment variable. Features can be specified with
  `cargoBuildNoDefaultFeatures` and `cargoBuildFeatures`. Additional
  Cargo build flags can be passed through `cargoBuildFlags`.
* `maturinBuildHook`: use [Maturin](https://github.com/PyO3/maturin)
  to build a Python wheel. Similar to `cargoBuildHook`, the optional
  variable `buildAndTestSubdir` can be used to build a crate in a
  Cargo workspace. Additional Maturin flags can be passed through
  `maturinBuildFlags`.
* `cargoCheckHook`: run tests using Cargo. The build type for checks
  can be set using `cargoCheckType`. Features can be specified with
  `cargoCheckNoDefaultFeatures` and `cargoCheckFeatures`. Additional
  flags can be passed to the tests using `checkFlags` and
  `checkFlagsArray`. By default, tests are run in parallel. This can
  be disabled by setting `dontUseCargoParallelTests`.
* `cargoNextestHook`: run tests using
  [cargo-nextest](https://github.com/nextest-rs/nextest). The same
  options for `cargoCheckHook` also applies to `cargoNextestHook`.
* `cargoInstallHook`: install binaries and static/shared libraries
  that were built using `cargoBuildHook`.
* `bindgenHook`: for crates which use `bindgen` as a build dependency, lets
  `bindgen` find `libclang` and `libclang` find the libraries in `buildInputs`.

#### Examples {#examples}

#### Python package using `setuptools-rust` {#python-package-using-setuptools-rust}

For Python packages using `setuptools-rust`, you can use
`fetchCargoTarball` and `cargoSetupHook` to retrieve and set up Cargo
dependencies. The build itself is then performed by
`buildPythonPackage`.

The following example outlines how the `tokenizers` Python package is
built. Since the Python package is in the `source/bindings/python`
directory of the `tokenizers` project's source archive, we use
`sourceRoot` to point the tooling to this directory:

```nix
{ fetchFromGitHub
, buildPythonPackage
, cargo
, rustPlatform
, rustc
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "tokenizers";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "python-v${version}";
    hash = "sha256-rQ2hRV52naEf6PvRsWVCTN7B1oXAQGmnpJw4iIdhamw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    name = "${pname}-${version}";
    hash = "sha256-miW//pnOmww2i6SOGbkrAIdc/JMDT4FJLqdMFojZeoY=";
  };

  sourceRoot = "${src.name}/bindings/python";

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools-rust
  ];

  # ...
}
```

In some projects, the Rust crate is not in the main Python source
directory.  In such cases, the `cargoRoot` attribute can be used to
specify the crate's directory relative to `sourceRoot`. In the
following example, the crate is in `src/rust`, as specified in the
`cargoRoot` attribute. Note that we also need to specify the correct
path for `fetchCargoTarball`.

```nix

{ buildPythonPackage
, fetchPypi
, rustPlatform
, setuptools-rust
, openssl
}:

buildPythonPackage rec {
  pname = "cryptography";
  version = "3.4.2"; # Also update the hash in vectors.nix

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xGDilsjLOnls3MfVbGKnj80KCUCczZxlis5PmHzpNcQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-PS562W4L1NimqDV2H0jl5vYhL08H9est/pbIxSdYVfo=";
  };

  cargoRoot = "src/rust";

  # ...
}
```

#### Python package using `maturin` {#python-package-using-maturin}

Python packages that use [Maturin](https://github.com/PyO3/maturin)
can be built with `fetchCargoTarball`, `cargoSetupHook`, and
`maturinBuildHook`. For example, the following (partial) derivation
builds the `retworkx` Python package. `fetchCargoTarball` and
`cargoSetupHook` are used to fetch and set up the crate dependencies.
`maturinBuildHook` is used to perform the build.

```nix
{ lib
, buildPythonPackage
, rustPlatform
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "retworkx";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "retworkx";
    rev = version;
    hash = "sha256-11n30ldg3y3y6qxg3hbj837pnbwjkqw3nxq6frds647mmmprrd20=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-heOBK8qi2nuc/Ib+I/vLzZ1fUUD/G/KTw9d7M4Hz5O0=";
  };

  format = "pyproject";

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  # ...
}
```

## `buildRustCrate`: Compiling Rust crates using Nix instead of Cargo {#compiling-rust-crates-using-nix-instead-of-cargo}

### Simple operation {#simple-operation}

When run, `cargo build` produces a file called `Cargo.lock`,
containing pinned versions of all dependencies. Nixpkgs contains a
tool called `crate2Nix` (`nix-shell -p crate2nix`), which can be
used to turn a `Cargo.lock` into a Nix expression.  That Nix
expression calls `rustc` directly (hence bypassing Cargo), and can
be used to compile a crate and all its dependencies.

See [`crate2nix`'s documentation](https://github.com/kolloch/crate2nix#known-restrictions)
for instructions on how to use it.

### Handling external dependencies {#handling-external-dependencies}

Some crates require external libraries. For crates from
[crates.io](https://crates.io), such libraries can be specified in
`defaultCrateOverrides` package in nixpkgs itself.

Starting from that file, one can add more overrides, to add features
or build inputs by overriding the hello crate in a separate file.

```nix
with import <nixpkgs> {};
((import ./hello.nix).hello {}).override {
  crateOverrides = defaultCrateOverrides // {
    hello = attrs: { buildInputs = [ openssl ]; };
  };
}
```

Here, `crateOverrides` is expected to be a attribute set, where the
key is the crate name without version number and the value a function.
The function gets all attributes passed to `buildRustCrate` as first
argument and returns a set that contains all attribute that should be
overwritten.

For more complicated cases, such as when parts of the crate's
derivation depend on the crate's version, the `attrs` argument of
the override above can be read, as in the following example, which
patches the derivation:

```nix
with import <nixpkgs> {};
((import ./hello.nix).hello {}).override {
  crateOverrides = defaultCrateOverrides // {
    hello = attrs: lib.optionalAttrs (lib.versionAtLeast attrs.version "1.0")  {
      postPatch = ''
        substituteInPlace lib/zoneinfo.rs \
          --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
      '';
    };
  };
}
```

Another situation is when we want to override a nested
dependency. This actually works in the exact same way, since the
`crateOverrides` parameter is forwarded to the crate's
dependencies. For instance, to override the build inputs for crate
`libc` in the example above, where `libc` is a dependency of the main
crate, we could do:

```nix
with import <nixpkgs> {};
((import hello.nix).hello {}).override {
  crateOverrides = defaultCrateOverrides // {
    libc = attrs: { buildInputs = []; };
  };
}
```

### Options and phases configuration {#options-and-phases-configuration}

Actually, the overrides introduced in the previous section are more
general. A number of other parameters can be overridden:

- The version of `rustc` used to compile the crate:

  ```nix
  (hello {}).override { rust = pkgs.rust; };
  ```

- Whether to build in release mode or debug mode (release mode by
  default):

  ```nix
  (hello {}).override { release = false; };
  ```

- Whether to print the commands sent to `rustc` when building
  (equivalent to `--verbose` in cargo:

  ```nix
  (hello {}).override { verbose = false; };
  ```

- Extra arguments to be passed to `rustc`:

  ```nix
  (hello {}).override { extraRustcOpts = "-Z debuginfo=2"; };
  ```

- Phases, just like in any other derivation, can be specified using
  the following attributes: `preUnpack`, `postUnpack`, `prePatch`,
  `patches`, `postPatch`, `preConfigure` (in the case of a Rust crate,
  this is run before calling the "build" script), `postConfigure`
  (after the "build" script),`preBuild`, `postBuild`, `preInstall` and
  `postInstall`. As an example, here is how to create a new module
  before running the build script:

  ```nix
  (hello {}).override {
    preConfigure = ''
       echo "pub const PATH=\"${hi.out}\";" >> src/path.rs"
    '';
  };
  ```

### Setting Up `nix-shell` {#setting-up-nix-shell}

Oftentimes you want to develop code from within `nix-shell`. Unfortunately
`buildRustCrate` does not support common `nix-shell` operations directly
(see [this issue](https://github.com/NixOS/nixpkgs/issues/37945))
so we will use `stdenv.mkDerivation` instead.

Using the example `hello` project above, we want to do the following:

- Have access to `cargo` and `rustc`
- Have the `openssl` library available to a crate through it's _normal_
  compilation mechanism (`pkg-config`).

A typical `shell.nix` might look like:

```nix
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "rust-env";
  nativeBuildInputs = [
    rustc cargo

    # Example Build-time Additional Dependencies
    pkg-config
  ];
  buildInputs = [
    # Example Run-time Additional Dependencies
    openssl
  ];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
}
```

You should now be able to run the following:

```ShellSession
$ nix-shell --pure
$ cargo build
$ cargo test
```

## Using community maintained Rust toolchains {#using-community-maintained-rust-toolchains}

::: {.note}
Note: The following projects cannot be used within nixpkgs since [IFD](#ssec-import-from-derivation) is disallowed.
To package things that require Rust nightly, `RUSTC_BOOTSTRAP = true;` can sometimes be used as a hack.
:::

There are two community maintained approaches to Rust toolchain management:
- [oxalica's Rust overlay](https://github.com/oxalica/rust-overlay)
- [fenix](https://github.com/nix-community/fenix)

Despite their names, both projects provides a similar set of packages and overlays under different APIs.

Oxalica's overlay allows you to select a particular Rust version without you providing a hash or a flake input,
but comes with a larger git repository than fenix.

Fenix also provides rust-analyzer nightly in addition to the Rust toolchains.

Both oxalica's overlay and fenix better integrate with nix and cache optimizations.
Because of this and ergonomics, either of those community projects
should be preferred to the Mozilla's Rust overlay ([nixpkgs-mozilla](https://github.com/mozilla/nixpkgs-mozilla)).

The following documentation demonstrates examples using fenix and oxalica's Rust overlay
with `nix-shell` and building derivations. More advanced usages like flake usage
are documented in their own repositories.

### Using Rust nightly with `nix-shell` {#using-rust-nightly-with-nix-shell}

Here is a simple `shell.nix` that provides Rust nightly (default profile) using fenix:

```nix
with import <nixpkgs> { };
let
  fenix = callPackage
    (fetchFromGitHub {
      owner = "nix-community";
      repo = "fenix";
      # commit from: 2023-03-03
      rev = "e2ea04982b892263c4d939f1cc3bf60a9c4deaa1";
      hash = "sha256-AsOim1A8KKtMWIxG+lXh5Q4P2bhOZjoUhFWJ1EuZNNk=";
    })
    { };
in
mkShell {
  name = "rust-env";
  nativeBuildInputs = [
    # Note: to use stable, just replace `default` with `stable`
    fenix.default.toolchain

    # Example Build-time Additional Dependencies
    pkg-config
  ];
  buildInputs = [
    # Example Run-time Additional Dependencies
    openssl
  ];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
}
```

Save this to `shell.nix`, then run:

```ShellSession
$ rustc --version
rustc 1.69.0-nightly (13471d3b2 2023-03-02)
```

To see that you are using nightly.

Oxalica's Rust overlay has more complete examples of `shell.nix` (and cross compilation) under its
[`examples` directory](https://github.com/oxalica/rust-overlay/tree/e53e8853aa7b0688bc270e9e6a681d22e01cf299/examples).

### Using Rust nightly in a derivation with `buildRustPackage` {#using-rust-nightly-in-a-derivation-with-buildrustpackage}

You can also use Rust nightly to build rust packages using `makeRustPlatform`.
The below snippet demonstrates invoking `buildRustPackage` with a Rust toolchain from oxalica's overlay:

```nix
with import <nixpkgs>
{
  overlays = [
    (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
  ];
};
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.stable.latest.minimal;
    rustc = rust-bin.stable.latest.minimal;
  };
in

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "12.1.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = version;
    hash = "sha256-+s5RBC3XSgb8omTbUNLywZnP6jSxZBKSS1BmXOjRF8M=";
  };

  cargoHash = "sha256-l1vL2ZdtDRxSGvP0X/l3nMw8+6WF67KPutJEzUROjg8=";

  doCheck = false;

  meta = with lib; {
    description = "A fast line-oriented regex search tool, similar to ag and ack";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = with licenses; [ mit unlicense ];
    maintainers = with maintainers; [];
  };
}
```

Follow the below steps to try that snippet.
1. save the above snippet as `default.nix` in that directory
2. cd into that directory and run `nix-build`

Fenix also has examples with `buildRustPackage`,
[crane](https://github.com/ipetkov/crane),
[naersk](https://github.com/nix-community/naersk),
and cross compilation in its [Examples](https://github.com/nix-community/fenix#examples) section.
