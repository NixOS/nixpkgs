# BEAM Languages (Erlang, Elixir & LFE) {#sec-beam}

## Introduction {#beam-introduction}

In this document and related Nix expressions, we use the term, _BEAM_, to describe the environment. BEAM is the name of the Erlang Virtual Machine and, as far as we're concerned, from a packaging perspective, all languages that run on the BEAM are interchangeable. That which varies, like the build system, is transparent to users of any given BEAM package, so we make no distinction.

## Available versions and deprecations schedule {#available-versions-and-deprecations-schedule}

### Elixir {#elixir}

nixpkgs follows the [official elixir deprecation schedule](https://hexdocs.pm/elixir/compatibility-and-deprecations.html) and keeps the last 5 released versions of Elixir available.

## Structure {#beam-structure}

All BEAM-related expressions are available via the top-level `beam` attribute, which includes:

- `interpreters`: a set of compilers running on the BEAM, including multiple Erlang/OTP versions (`beam.interpreters.erlang_22`, etc), Elixir (`beam.interpreters.elixir`) and LFE (Lisp Flavoured Erlang) (`beam.interpreters.lfe`).

- `packages`: a set of package builders (Mix and rebar3), each compiled with a specific Erlang/OTP version, e.g. `beam.packages.erlang22`.

The default Erlang compiler, defined by `beam.interpreters.erlang`, is aliased as `erlang`. The default BEAM package set is defined by `beam.packages.erlang` and aliased at the top level as `beamPackages`.

To create a package builder built with a custom Erlang version, use the lambda, `beam.packagesWith`, which accepts an Erlang/OTP derivation and produces a package builder similar to `beam.packages.erlang`.

Many Erlang/OTP distributions available in `beam.interpreters` have versions with ODBC and/or Java enabled or without wx (no observer support). For example, there's `beam.interpreters.erlang_22_odbc_javac`, which corresponds to `beam.interpreters.erlang_22` and `beam.interpreters.erlang_22_nox`, which corresponds to `beam.interpreters.erlang_22`.

## Build Tools {#build-tools}

### Rebar3 {#build-tools-rebar3}

We provide a version of Rebar3, under `rebar3`. We also provide a helper to fetch Rebar3 dependencies from a lockfile under `fetchRebar3Deps`.

We also provide a version on Rebar3 with plugins included, under `rebar3WithPlugins`. This package is a function which takes two arguments: `plugins`, a list of nix derivations to include as plugins (loaded only when specified in `rebar.config`), and `globalPlugins`, which should always be loaded by rebar3. Example: `rebar3WithPlugins { globalPlugins = [beamPackages.pc]; }`.

When adding a new plugin it is important that the `packageName` attribute is the same as the atom used by rebar3 to refer to the plugin.

### Mix & Erlang.mk {#build-tools-other}

Erlang.mk works exactly as expected. There is a bootstrap process that needs to be run, which is supported by the `buildErlangMk` derivation.

For Elixir applications use `mixRelease` to make a release. See examples for more details.

There is also a `buildMix` helper, whose behavior is closer to that of `buildErlangMk` and `buildRebar3`. The primary difference is that mixRelease makes a release, while buildMix only builds the package, making it useful for libraries and other dependencies.

## How to Install BEAM Packages {#how-to-install-beam-packages}

BEAM builders are not registered at the top level, because they are not relevant to the vast majority of Nix users.
To use any of those builders into your environment, refer to them by their attribute path under `beamPackages`, e.g. `beamPackages.rebar3`:

::: {.example #ex-beam-ephemeral-shell}
# Ephemeral shell

```ShellSession
$ nix-shell -p beamPackages.rebar3
```
:::

::: {.example #ex-beam-declarative-shell}
# Declarative shell

```nix
let
  pkgs = import <nixpkgs> { config = {}; overlays = []; };
in
pkgs.mkShell {
  packages = [ pkgs.beamPackages.rebar3 ];
}
```
:::

## Packaging BEAM Applications {#packaging-beam-applications}

### Erlang Applications {#packaging-erlang-applications}

#### Rebar3 Packages {#rebar3-packages}

The Nix function, `buildRebar3`, defined in `beam.packages.erlang.buildRebar3` and aliased at the top level, can be used to build a derivation that understands how to build a Rebar3 project.

If a package needs to compile native code via Rebar3's port compilation mechanism, add `compilePort = true;` to the derivation.

#### Erlang.mk Packages {#erlang-mk-packages}

Erlang.mk functions similarly to Rebar3, except we use `buildErlangMk` instead of `buildRebar3`.

#### Mix Packages {#mix-packages}

`mixRelease` is used to make a release in the mix sense. Dependencies will need to be fetched with `fetchMixDeps` and passed to it.

#### mixRelease - Elixir Phoenix example {#mix-release-elixir-phoenix-example}

there are 3 steps, frontend dependencies (javascript), backend dependencies (elixir) and the final derivation that puts both of those together

##### mixRelease - Frontend dependencies (javascript) {#mix-release-javascript-deps}

For phoenix projects, inside of nixpkgs you can either use yarn2nix (mkYarnModule) or node2nix. An example with yarn2nix can be found [here](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/web-apps/plausible/default.nix#L39). An example with node2nix will follow. To package something outside of nixpkgs, you have alternatives like [npmlock2nix](https://github.com/nix-community/npmlock2nix) or [nix-npm-buildpackage](https://github.com/serokell/nix-npm-buildpackage)

##### mixRelease - backend dependencies (mix) {#mix-release-mix-deps}

There are 2 ways to package backend dependencies. With mix2nix and with a fixed-output-derivation (FOD).

###### mix2nix {#mix2nix}

`mix2nix` is a cli tool available in nixpkgs. it will generate a nix expression from a mix.lock file. It is quite standard in the 2nix tool series.

Note that currently mix2nix can't handle git dependencies inside the mix.lock file. If you have git dependencies, you can either add them manually (see [example](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/pleroma/default.nix#L20)) or use the FOD method.

The advantage of using mix2nix is that nix will know your whole dependency graph. On a dependency update, this won't trigger a full rebuild and download of all the dependencies, where FOD will do so.

Practical steps:

- run `mix2nix > mix_deps.nix` in the upstream repo.
- pass `mixNixDeps = with pkgs; import ./mix_deps.nix { inherit lib beamPackages; };` as an argument to mixRelease.

If there are git dependencies.

- You'll need to fix the version artificially in mix.exs and regenerate the mix.lock with fixed version (on upstream). This will enable you to run `mix2nix > mix_deps.nix`.
- From the mix_deps.nix file, remove the dependencies that had git versions and pass them as an override to the import function.

```nix
{
  mixNixDeps = import ./mix.nix {
    inherit beamPackages lib;
    overrides = (final: prev: {
      # mix2nix does not support git dependencies yet,
      # so we need to add them manually
      prometheus_ex = beamPackages.buildMix rec {
        name = "prometheus_ex";
        version = "3.0.5";

        # Change the argument src with the git src that you actually need
        src = fetchFromGitLab {
          domain = "git.pleroma.social";
          group = "pleroma";
          owner = "elixir-libraries";
          repo = "prometheus.ex";
          rev = "a4e9beb3c1c479d14b352fd9d6dd7b1f6d7deee5";
          hash = "sha256-U17LlN6aGUKUFnT4XyYXppRN+TvUBIBRHEUsfeIiGOw=";
        };
        # you can re-use the same beamDeps argument as generated
        beamDeps = with final; [ prometheus ];
      };
    });
  };
}
```

You will need to run the build process once to fix the hash to correspond to your new git src.

###### FOD {#fixed-output-derivation}

A fixed output derivation will download mix dependencies from the internet. To ensure reproducibility, a hash will be supplied. Note that mix is relatively reproducible. An FOD generating a different hash on each run hasn't been observed (as opposed to npm where the chances are relatively high). See [elixir-ls](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/beam-modules/elixir-ls/default.nix) for a usage example of FOD.

Practical steps

- start with the following argument to mixRelease

```nix
{
  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = lib.fakeHash;
  };
}
```

The first build will complain about the hash value, you can replace with the suggested value after that.

Note that if after you've replaced the value, nix suggests another hash, then mix is not fetching the dependencies reproducibly. An FOD will not work in that case and you will have to use mix2nix.

##### mixRelease - example {#mix-release-example}

Here is how your `default.nix` file would look for a phoenix project.

```nix
with import <nixpkgs> { };

let
  # beam.interpreters.erlang_26 is available if you need a particular version
  packages = beam.packagesWith beam.interpreters.erlang;

  pname = "your_project";
  version = "0.0.1";

  src = builtins.fetchgit {
    url = "ssh://git@github.com/your_id/your_repo";
    rev = "replace_with_your_commit";
  };

  # if using mix2nix you can use the mixNixDeps attribute
  mixFodDeps = packages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    # nix will complain and tell you the right value to replace this with
    hash = lib.fakeHash;
    mixEnv = ""; # default is "prod", when empty includes all dependencies, such as "dev", "test".
    # if you have build time environment variables add them here
    MY_ENV_VAR="my_value";
  };

  nodeDependencies = (pkgs.callPackage ./assets/default.nix { }).shell.nodeDependencies;

in packages.mixRelease {
  inherit src pname version mixFodDeps;
  # if you have build time environment variables add them here
  MY_ENV_VAR="my_value";

  postBuild = ''
    ln -sf ${nodeDependencies}/lib/node_modules assets/node_modules
    npm run deploy --prefix ./assets

    # for external task you need a workaround for the no deps check flag
    # https://github.com/phoenixframework/phoenix/issues/2690
    mix do deps.loadpaths --no-deps-check, phx.digest
    mix phx.digest --no-deps-check
  '';
}
```

Setup will require the following steps:

- Move your secrets to runtime environment variables. For more information refer to the [runtime.exs docs](https://hexdocs.pm/mix/Mix.Tasks.Release.html#module-runtime-configuration). On a fresh Phoenix build that would mean that both `DATABASE_URL` and `SECRET_KEY` need to be moved to `runtime.exs`.
- `cd assets` and `nix-shell -p node2nix --run "node2nix --development"` will generate a Nix expression containing your frontend dependencies
- commit and push those changes
- you can now `nix-build .`
- To run the release, set the `RELEASE_TMP` environment variable to a directory that your program has write access to. It will be used to store the BEAM settings.

#### Example of creating a service for an Elixir - Phoenix project {#example-of-creating-a-service-for-an-elixir---phoenix-project}

In order to create a service with your release, you could add a `service.nix`
in your project with the following

```nix
{config, pkgs, lib, ...}:

let
  release = pkgs.callPackage ./default.nix;
  release_name = "app";
  working_directory = "/home/app";
in
{
  systemd.services.${release_name} = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "postgresql.service" ];
    # note that if you are connecting to a postgres instance on a different host
    # postgresql.service should not be included in the requires.
    requires = [ "network-online.target" "postgresql.service" ];
    description = "my app";
    environment = {
      # RELEASE_TMP is used to write the state of the
      # VM configuration when the system is running
      # it needs to be a writable directory
      RELEASE_TMP = working_directory;
      # can be generated in an elixir console with
      # Base.encode32(:crypto.strong_rand_bytes(32))
      RELEASE_COOKIE = "my_cookie";
      MY_VAR = "my_var";
    };
    serviceConfig = {
      Type = "exec";
      DynamicUser = true;
      WorkingDirectory = working_directory;
      # Implied by DynamicUser, but just to emphasize due to RELEASE_TMP
      PrivateTmp = true;
      ExecStart = ''
        ${release}/bin/${release_name} start
      '';
      ExecStop = ''
        ${release}/bin/${release_name} stop
      '';
      ExecReload = ''
        ${release}/bin/${release_name} restart
      '';
      Restart = "on-failure";
      RestartSec = 5;
      StartLimitBurst = 3;
      StartLimitInterval = 10;
    };
    # disksup requires bash
    path = [ pkgs.bash ];
  };

  # in case you have migration scripts or you want to use a remote shell
  environment.systemPackages = [ release ];
}
```

## How to Develop {#how-to-develop}

### Creating a Shell {#creating-a-shell}

Usually, we need to create a `shell.nix` file and do our development inside of the environment specified therein. Just install your version of Erlang and any other interpreters, and then use your normal build tools. As an example with Elixir:

```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
  elixir = beam.packages.erlang_24.elixir_1_18;
in
mkShell {
  buildInputs = [ elixir ];
}
```

### Using an overlay {#beam-using-overlays}

If you need to use an overlay to change some attributes of a derivation, e.g. if you need a bugfix from a version that is not yet available in nixpkgs, you can override attributes such as `version` (and the corresponding `hash`) and then use this overlay in your development environment:

#### `shell.nix` {#beam-using-overlays-shell.nix}

```nix
let
  elixir_1_18_1_overlay = (self: super: {
      elixir_1_18 = super.elixir_1_18.override {
        version = "1.18.1";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
    });
  pkgs = import <nixpkgs> { overlays = [ elixir_1_18_1_overlay ]; };
in
with pkgs;
mkShell {
  buildInputs = [
    elixir_1_18
  ];
}
```

#### Elixir - Phoenix project {#elixir---phoenix-project}

Here is an example `shell.nix`.

```nix
with import <nixpkgs> { };

let
  # define packages to install
  basePackages = [
    git
    # replace with beam.packages.erlang.elixir_1_18 if you need
    beam.packages.erlang.elixir
    nodejs
    postgresql_14
    # only used for frontend dependencies
    # you are free to use yarn2nix as well
    nodePackages.node2nix
    # formatting js file
    nodePackages.prettier
  ];

  inputs = basePackages ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin
    (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]);

  # define shell startup command
  hooks = ''
    # this allows mix to work on the local directory
    mkdir -p .nix-mix .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-mix
    # make hex from Nixpkgs available
    # `mix local.hex` will install hex into MIX_HOME and should take precedence
    export MIX_PATH="${beam.packages.erlang.hex}/lib/erlang/lib/hex/ebin"
    export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
    export LANG=C.UTF-8
    # keep your shell history in iex
    export ERL_AFLAGS="-kernel shell_history enabled"

    # postges related
    # keep all your db data in a folder inside the project
    export PGDATA="$PWD/db"

    # phoenix related env vars
    export POOL_SIZE=15
    export DB_URL="postgresql://postgres:postgres@localhost:5432/db"
    export PORT=4000
    export MIX_ENV=dev
    # add your project env vars here, word readable in the nix store.
    export ENV_VAR="your_env_var"
  '';

in mkShell {
  buildInputs = inputs;
  shellHook = hooks;
}
```

Initializing the project will require the following steps:

- create the db directory `initdb ./db` (inside your mix project folder)
- create the postgres user `createuser postgres -ds`
- create the db `createdb db`
- start the postgres instance `pg_ctl -l "$PGDATA/server.log" start`
- add the `/db` folder to your `.gitignore`
- you can start your phoenix server and get a shell with `iex -S mix phx.server`
