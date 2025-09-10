# Ruby {#sec-language-ruby}

## Using Ruby {#using-ruby}

Several versions of Ruby interpreters are available on Nix, as well as over 250 gems and many applications written in Ruby. The attribute `ruby` refers to the default Ruby interpreter, which is currently MRI 3.3. It's also possible to refer to specific versions, e.g. `ruby_3_y`, `jruby`, or `mruby`.

In the Nixpkgs tree, Ruby packages can be found throughout, depending on what they do, and are called from the main package set. Ruby gems, however are separate sets, and there's one default set for each interpreter (currently MRI only).

There are two main approaches for using Ruby with gems. One is to use a specifically locked `Gemfile` for an application that has very strict dependencies. The other is to depend on the common gems, which we'll explain further down, and rely on them being updated regularly.

The interpreters have common attributes, namely `gems`, and `withPackages`. So you can refer to `ruby.gems.nokogiri`, or `ruby_3_2.gems.nokogiri` to get the Nokogiri gem already compiled and ready to use.

Since not all gems have executables like `nokogiri`, it's usually more convenient to use the `withPackages` function like this: `ruby.withPackages (p: with p; [ nokogiri ])`. This will also make sure that the Ruby in your environment will be able to find the gem and it can be used in your Ruby code (for example via `ruby` or `irb` executables) via `require "nokogiri"` as usual.

### Temporary Ruby environment with `nix-shell` {#temporary-ruby-environment-with-nix-shell}

Rather than having a single Ruby environment shared by all Ruby development projects on a system, Nix allows you to create separate environments per project. `nix-shell` gives you the possibility to temporarily load another environment akin to a combined `chruby` or `rvm` and `bundle exec`.

There are two methods for loading a shell with Ruby packages. The first and recommended method is to create an environment with `ruby.withPackages` and load that.

```ShellSession
$ nix-shell -p "ruby.withPackages (ps: with ps; [ nokogiri pry ])"
```

The other method, which is not recommended, is to create an environment and list all the packages directly.

```ShellSession
$ nix-shell -p ruby.gems.nokogiri ruby.gems.pry
```

Again, it's possible to launch the interpreter from the shell. The Ruby interpreter has the attribute `gems` which contains all Ruby gems for that specific interpreter.

#### Load Ruby environment from `.nix` expression {#load-ruby-environment-from-.nix-expression}

As explained [in the `nix-shell` section](https://nixos.org/manual/nix/stable/command-ref/nix-shell) of the Nix manual, `nix-shell` can also load an expression from a `.nix` file.
Say we want to have Ruby, `nokogori`, and `pry`. Consider a `shell.nix` file with:

```nix
with import <nixpkgs> { };
ruby.withPackages (
  ps: with ps; [
    nokogiri
    pry
  ]
)
```

What's happening here?

1. We begin with importing the Nix Packages collections. `import <nixpkgs>` imports the `<nixpkgs>` function, `{}` calls it and the `with` statement brings all attributes of `nixpkgs` in the local scope. These attributes form the main package set.
2. Then we create a Ruby environment with the `withPackages` function.
3. The `withPackages` function expects us to provide a function as an argument that takes the set of all ruby gems and returns a list of packages to include in the environment. Here, we select the packages `nokogiri` and `pry` from the package set.

#### Execute command with `--run` {#execute-command-with---run}

A convenient flag for `nix-shell` is `--run`. It executes a command in the `nix-shell`. We can e.g. directly open a `pry` REPL:

```ShellSession
$ nix-shell -p "ruby.withPackages (ps: with ps; [ nokogiri pry ])" --run "pry"
```

Or immediately require `nokogiri` in pry:

```ShellSession
$ nix-shell -p "ruby.withPackages (ps: with ps; [ nokogiri pry ])" --run "pry -rnokogiri"
```

Or run a script using this environment:

```ShellSession
$ nix-shell -p "ruby.withPackages (ps: with ps; [ nokogiri pry ])" --run "ruby example.rb"
```

#### Using `nix-shell` as shebang {#using-nix-shell-as-shebang}

In fact, for the last case, there is a more convenient method. You can add a [shebang](<https://en.wikipedia.org/wiki/Shebang_(Unix)>) to your script specifying which dependencies `nix-shell` needs. With the following shebang, you can just execute `./example.rb`, and it will run with all dependencies.

```ruby
#! /usr/bin/env nix-shell
#! nix-shell -i ruby -p "ruby.withPackages (ps: with ps; [ nokogiri rest-client ])"

require 'nokogiri'
require 'rest-client'

body = RestClient.get('http://example.com').body
puts Nokogiri::HTML(body).at('h1').text
```

## Developing with Ruby {#developing-with-ruby}

### Using an existing Gemfile {#using-an-existing-gemfile}

In most cases, you'll already have a `Gemfile.lock` listing all your dependencies. This can be used to generate a `gemset.nix` which is used to fetch the gems and combine them into a single environment. The reason why you need to have a separate file for this, is that Nix requires you to have a checksum for each input to your build. Since the `Gemfile.lock` that `bundler` generates doesn't provide us with checksums, we have to first download each gem, calculate its SHA256, and store it in this separate file.

So the steps from having just a `Gemfile` to a `gemset.nix` are:

```ShellSession
$ bundle lock
$ bundix
```

If you already have a `Gemfile.lock`, you can run `bundix` and it will work the same.

To update the gems in your `Gemfile.lock`, you may use the `bundix -l` flag, which will create a new `Gemfile.lock` in case the `Gemfile` has a more recent time of modification.

Once the `gemset.nix` is generated, it can be used in a `bundlerEnv` derivation. Here is an example you could use for your `shell.nix`:

```nix
# ...
let
  gems = bundlerEnv {
    name = "gems-for-some-project";
    gemdir = ./.;
  };
in
mkShell {
  packages = [
    gems
    gems.wrappedRuby
  ];
}
```

With this file in your directory, you can run `nix-shell` to build and use the gems. The important parts here are `bundlerEnv` and `wrappedRuby`.

The `bundlerEnv` is a wrapper over all the gems in your gemset. This means that all the `/lib` and `/bin` directories will be available, and the executables of all gems (even of indirect dependencies) will end up in your `$PATH`. The `wrappedRuby` provides you with all executables that come with Ruby itself, but wrapped so they can easily find the gems in your gemset.

One common issue that you might have is that you have Ruby, but also `bundler` in your gemset. That leads to a conflict for `/bin/bundle` and `/bin/bundler`. You can resolve this by wrapping either your Ruby or your gems in a `lowPrio` call. So in order to give the `bundler` from your gemset priority, it would be used like this:

```nix
# ...
mkShell {
  buildInputs = [
    gems
    (lowPrio gems.wrappedRuby)
  ];
}
```

Sometimes a Gemfile references other files. Such as `.ruby-version` or vendored gems. When copying the Gemfile to the nix store we need to copy those files alongside. This can be done using `extraConfigPaths`. For example:

```nix
{
  gems = bundlerEnv {
    name = "gems-for-some-project";
    gemdir = ./.;
    extraConfigPaths = [ "${./.}/.ruby-version" ];
  };
}
```

### Gem-specific configurations and workarounds {#gem-specific-configurations-and-workarounds}

In some cases, especially if the gem has native extensions, you might need to modify the way the gem is built.

This is done via a common configuration file that includes all of the workarounds for each gem.

This file lives at `/pkgs/development/ruby-modules/gem-config/default.nix`, since it already contains a lot of entries, it should be pretty easy to add the modifications you need for your needs.

In the meanwhile, or if the modification is for a private gem, you can also add the configuration to only your own environment.

Two places that allow this modification are the `ruby` derivation, or `bundlerEnv`.

Here's the `ruby` one:

```nix
{
  pg_version ? "10",
  pkgs ? import <nixpkgs> { },
}:
let
  myRuby = pkgs.ruby.override {
    defaultGemConfig = pkgs.defaultGemConfig // {
      pg = attrs: {
        buildFlags = [
          "--with-pg-config=${pkgs."postgresql_${pg_version}".pg_config}/bin/pg_config"
        ];
      };
    };
  };
in
myRuby.withPackages (ps: with ps; [ pg ])
```

And an example with `bundlerEnv`:

```nix
{
  pg_version ? "10",
  pkgs ? import <nixpkgs> { },
}:
let
  gems = pkgs.bundlerEnv {
    name = "gems-for-some-project";
    gemdir = ./.;
    gemConfig = pkgs.defaultGemConfig // {
      pg = attrs: {
        buildFlags = [
          "--with-pg-config=${pkgs."postgresql_${pg_version}".pg_config}/bin/pg_config"
        ];
      };
    };
  };
in
mkShell {
  buildInputs = [
    gems
    gems.wrappedRuby
  ];
}
```

And finally via overlays:

```nix
{
  pg_version ? "10",
}:
let
  pkgs = import <nixpkgs> {
    overlays = [
      (self: super: {
        defaultGemConfig = super.defaultGemConfig // {
          pg = attrs: {
            buildFlags = [
              "--with-pg-config=${pkgs."postgresql_${pg_version}".pg_config}/bin/pg_config"
            ];
          };
        };
      })
    ];
  };
in
pkgs.ruby.withPackages (ps: with ps; [ pg ])
```

Then we can get whichever postgresql version we desire and the `pg` gem will always reference it correctly:

```ShellSession
$ nix-shell --argstr pg_version 9_4 --run 'ruby -rpg -e "puts PG.library_version"'
90421

$ nix-shell --run 'ruby -rpg -e "puts PG.library_version"'
100007
```

Of course for this use-case one could also use overlays since the configuration for `pg` depends on the `postgresql` alias, but for demonstration purposes this has to suffice.

### Platform-specific gems {#ruby-platform-specif-gems}

Right now, bundix has some issues with pre-built, platform-specific gems: [bundix PR #68](https://github.com/nix-community/bundix/pull/68).
Until this is solved, you can tell bundler to not use platform-specific gems and instead build them from source each time:
- globally (will be set in `~/.config/.bundle/config`):
```shell
$ bundle config set force_ruby_platform true
```
- locally (will be set in `<project-root>/.bundle/config`):
```shell
$ bundle config set --local force_ruby_platform true
```

### Adding a gem to the default gemset {#adding-a-gem-to-the-default-gemset}

Now that you know how to get a working Ruby environment with Nix, it's time to go forward and start actually developing with Ruby. We will first have a look at how Ruby gems are packaged on Nix. Then, we will look at how you can use development mode with your code.

All gems in the standard set are automatically generated from a single `Gemfile`. The dependency resolution is done with `bundler` and makes it more likely that all gems are compatible with each other.

In order to add a new gem to nixpkgs, you can put it into the `/pkgs/development/ruby-modules/with-packages/Gemfile` and run `./maintainers/scripts/update-ruby-packages`.

To test that it works, you can then try using the gem with:

```shell
NIX_PATH=nixpkgs=$PWD nix-shell -p "ruby.withPackages (ps: with ps; [ name-of-your-gem ])"
```

### Packaging applications {#packaging-applications}

A common task is to add a Ruby executable to Nixpkgs; popular examples would be `chef`, `jekyll`, or `sass`. A good way to do that is to use the `bundlerApp` function, that allows you to make a package that only exposes the listed executables. Otherwise, the package may cause conflicts through common paths like `bin/rake` or `bin/bundler` that aren't meant to be used.

The absolute easiest way to do that is to write a `Gemfile` along these lines:

```ruby
source 'https://rubygems.org' do
  gem 'mdl'
end
```

If you want to package a specific version, you can use the standard Gemfile syntax for that, e.g. `gem 'mdl', '0.5.0'`, but if you want the latest stable version anyway, it's easier to update by running the `bundle lock` and `bundix` steps again.

Now you can also make a `default.nix` that looks like this:

```nix
{ bundlerApp }:

bundlerApp {
  pname = "mdl";
  gemdir = ./.;
  exes = [ "mdl" ];
}
```

All that's left to do is to generate the corresponding `Gemfile.lock` and `gemset.nix` as described above in the `Using an existing Gemfile` section.

#### Packaging executables that require wrapping {#packaging-executables-that-require-wrapping}

Sometimes your app will depend on other executables at runtime and try to find them through the `PATH` environment variable.

In this case, you can provide a `postBuild` hook to `bundlerApp` that wraps the gem in another script that prefixes the `PATH`.

Of course you could also make a custom `gemConfig` if you know exactly how to patch it, but it's usually much easier to maintain with a simple wrapper so the patch doesn't have to be adjusted for each version.

Here's another example:

```nix
{
  lib,
  bundlerApp,
  makeWrapper,
  git,
  gnutar,
  gzip,
}:

bundlerApp {
  pname = "r10k";
  gemdir = ./.;
  exes = [ "r10k" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/r10k --prefix PATH : ${
      lib.makeBinPath [
        git
        gnutar
        gzip
      ]
    }
  '';
}
```
