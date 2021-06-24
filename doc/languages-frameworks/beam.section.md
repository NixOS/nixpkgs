# BEAM Languages (Erlang, Elixir & LFE) {#sec-beam}

## Introduction {#beam-introduction}

In this document and related Nix expressions, we use the term, _BEAM_, to describe the environment. BEAM is the name of the Erlang Virtual Machine and, as far as we're concerned, from a packaging perspective, all languages that run on the BEAM are interchangeable. That which varies, like the build system, is transparent to users of any given BEAM package, so we make no distinction.

## Structure {#beam-structure}

All BEAM-related expressions are available via the top-level `beam` attribute, which includes:

- `interpreters`: a set of compilers running on the BEAM, including multiple Erlang/OTP versions (`beam.interpreters.erlangR19`, etc), Elixir (`beam.interpreters.elixir`) and LFE (Lisp Flavoured Erlang) (`beam.interpreters.lfe`).

- `packages`: a set of package builders (Mix and rebar3), each compiled with a specific Erlang/OTP version, e.g. `beam.packages.erlangR19`.

The default Erlang compiler, defined by `beam.interpreters.erlang`, is aliased as `erlang`. The default BEAM package set is defined by `beam.packages.erlang` and aliased at the top level as `beamPackages`.

To create a package builder built with a custom Erlang version, use the lambda, `beam.packagesWith`, which accepts an Erlang/OTP derivation and produces a package builder similar to `beam.packages.erlang`.

Many Erlang/OTP distributions available in `beam.interpreters` have versions with ODBC and/or Java enabled or without wx (no observer support). For example, there's `beam.interpreters.erlangR22_odbc_javac`, which corresponds to `beam.interpreters.erlangR22` and `beam.interpreters.erlangR22_nox`, which corresponds to `beam.interpreters.erlangR22`.

## Build Tools {#build-tools}

### Rebar3 {#build-tools-rebar3}

We provide a version of Rebar3, under `rebar3`. We also provide a helper to fetch Rebar3 dependencies from a lockfile under `fetchRebar3Deps`.

### Mix & Erlang.mk {#build-tools-other}

Erlang.mk works exactly as expected. There is a bootstrap process that needs to be run, which is supported by the `buildErlangMk` derivation.

For Elixir applications use `mixRelease` to make a release. See examples for more details.

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

`mixRelease` is used to make a release in the mix sense. Dependencies will need to be fetched with `fetchMixDeps` and passed to it.

#### mixRelease - Elixir Phoenix example

Here is how your `default.nix` file would look.

```nix
with import <nixpkgs> { };

let
  packages = beam.packagesWith beam.interpreters.erlang;
  src = builtins.fetchgit {
    url = "ssh://git@github.com/your_id/your_repo";
    rev = "replace_with_your_commit";
  };

  pname = "your_project";
  version = "0.0.1";
  mixEnv = "prod";

  mixDeps = packages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src mixEnv version;
    # nix will complain and tell you the right value to replace this with
    sha256 = lib.fakeSha256;
    # if you have build time environment variables add them here
    MY_ENV_VAR="my_value";
  };

  nodeDependencies = (pkgs.callPackage ./assets/default.nix { }).shell.nodeDependencies;

  frontEndFiles = stdenvNoCC.mkDerivation {
    pname = "frontend-${pname}";

    nativeBuildInputs = [ nodejs ];

    inherit version src;

    buildPhase = ''
      cp -r ./assets $TEMPDIR

      mkdir -p $TEMPDIR/assets/node_modules/.cache
      cp -r ${nodeDependencies}/lib/node_modules $TEMPDIR/assets
      export PATH="${nodeDependencies}/bin:$PATH"

      cd $TEMPDIR/assets
      webpack --config ./webpack.config.js
      cd ..
    '';

    installPhase = ''
      cp -r ./priv/static $out/
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    # nix will complain and tell you the right value to replace this with
    outputHash = lib.fakeSha256;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;
  };


in packages.mixRelease {
  inherit src pname version mixEnv mixDeps;
  # if you have build time environment variables add them here
  MY_ENV_VAR="my_value";
  preInstall = ''
    mkdir -p ./priv/static
    cp -r ${frontEndFiles} ./priv/static
  '';
}
```

Setup will require the following steps:

- Move your secrets to runtime environment variables. For more information refer to the [runtime.exs docs](https://hexdocs.pm/mix/Mix.Tasks.Release.html#module-runtime-configuration). On a fresh Phoenix build that would mean that both `DATABASE_URL` and `SECRET_KEY` need to be moved to `runtime.exs`.
- `cd assets` and `nix-shell -p node2nix --run node2nix --development` will generate a Nix expression containing your frontend dependencies
- commit and push those changes
- you can now `nix-build .`
- To run the release, set the `RELEASE_TMP` environment variable to a directory that your program has write access to. It will be used to store the BEAM settings.

#### Example of creating a service for an Elixir - Phoenix project

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

  environment.systemPackages = [ release ];
}
```

## How to Develop {#how-to-develop}

### Creating a Shell {#creating-a-shell}

Usually, we need to create a `shell.nix` file and do our development inside of the environment specified therein. Just install your version of Erlang and any other interpreters, and then use your normal build tools. As an example with Elixir:

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

#### Elixir - Phoenix project

Here is an example `shell.nix`.

```nix
with import <nixpkgs> { };

let
  # define packages to install
  basePackages = [
    git
    # replace with beam.packages.erlang.elixir_1_11 if you need
    beam.packages.erlang.elixir
    nodejs-15_x
    postgresql_13
    # only used for frontend dependencies
    # you are free to use yarn2nix as well
    nodePackages.node2nix
    # formatting js file
    nodePackages.prettier
  ];

  inputs = basePackages ++ lib.optionals stdenv.isLinux [ inotify-tools ]
    ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]);

  # define shell startup command
  hooks = ''
    # this allows mix to work on the local directory
    mkdir -p .nix-mix .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-mix
    export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
    # TODO: not sure how to make hex available without installing it afterwards.
    mix local.hex --if-missing
    export LANG=en_US.UTF-8
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
