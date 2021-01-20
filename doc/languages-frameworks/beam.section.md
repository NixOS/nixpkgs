# BEAM Languages (Erlang, Elixir & LFE) {#sec-beam}

## Introduction {#beam-introduction}

In this document and related Nix expressions, we use the term, *BEAM*, to describe the environment. BEAM is the name of the Erlang Virtual Machine and, as far as we're concerned, from a packaging perspective, all languages that run on the BEAM are interchangeable. That which varies, like the build system, is transparent to users of any given BEAM package, so we make no distinction.

## Structure {#beam-structure}

All BEAM-related expressions are available via the top-level `beam` attribute, which includes:

  - `interpreters`: a set of compilers running on the BEAM, including multiple Erlang/OTP versions (`beam.interpreters.erlangR19`, etc), Elixir (`beam.interpreters.elixir`) and LFE (`beam.interpreters.lfe`).

  - `packages`: a set of package builders (Mix and rebar3), each compiled with a specific Erlang/OTP version, e.g.  `beam.packages.erlangR19`.

The default Erlang compiler, defined by `beam.interpreters.erlang`, is aliased as `erlang`. The default BEAM package set is defined by `beam.packages.erlang` and aliased at the top level as `beamPackages`.

To create a package builder built with a custom Erlang version, use the lambda, `beam.packagesWith`, which accepts an Erlang/OTP derivation and produces a package builder similar to `beam.packages.erlang`.

Many Erlang/OTP distributions available in `beam.interpreters` have versions with ODBC and/or Java enabled or without wx (no observer support). For example, there's `beam.interpreters.erlangR22_odbc_javac`, which corresponds to `beam.interpreters.erlangR22` and `beam.interpreters.erlangR22_nox`, which corresponds to `beam.interpreters.erlangR22`.

## Build Tools {#build-tools}

### Rebar3 {#build-tools-rebar3}

We provide a version of Rebar3, under `rebar3`. We also provide a helper to fetch Rebar3 dependencies from a lockfile under `fetchRebar3Deps`.

### Mix & Erlang.mk {#build-tools-other}

Both Mix and Erlang.mk work exactly as expected. There is a bootstrap process that needs to be run for both, however, which is supported by the `buildMix` and `buildErlangMk` derivations, respectively.

## How to Install BEAM Packages {#how-to-install-beam-packages}

BEAM builders are not registered at the top level, simply because they are not relevant to the vast majority of Nix users. To install any of those builders into your profile, refer to them by their attribute path `beamPackages.rebar3`:

```ShellSession
$ nix-env -f "<nixpkgs>" -iA beamPackages.rebar3
```

## Packaging BEAM Applications {#packaging-beam-applications}

### Erlang Applications {#packaging-erlang-applications}

#### Rebar3 Packages {#rebar3-packages}

The Nix function, `buildRebar3`, defined in `beam.packages.erlang.buildRebar3` and aliased at the top level, can be used to build a derivation that understands how to build a Rebar3 project.

If a package needs to compile native code via Rebar3's port compilation mechanism, add `compilePort = true;` to the derivation.

#### Erlang.mk Packages {#erlang-mk-packages}

Erlang.mk functions similarly to Rebar3, except we use `buildErlangMk` instead of `buildRebar3`.

#### Mix Packages {#mix-packages}

Mix functions similarly to Rebar3, except we use `buildMix` instead of `buildRebar3`.

Alternatively, we can use `buildHex` as a shortcut:

## How to Develop {#how-to-develop}

### Creating a Shell {#creating-a-shell}

Usually, we need to create a `shell.nix` file and do our development inside of the environment specified therein. Just install your version of erlang and other interpreter, and then user your normal build tools.  As an example with elixir:

```nix
{ pkgs ? import "<nixpkgs"> {} }:

with pkgs;

let

  elixir = beam.packages.erlangR22.elixir_1_9;

in
mkShell {
  buildInputs = [ elixir ];

  ERL_INCLUDE_PATH="${erlang}/lib/erlang/usr/include";
}
```

#### Building in a Shell (for Mix Projects) {#building-in-a-shell}

Using a `shell.nix` as described (see <xref linkend="creating-a-shell"/>) should just work.
