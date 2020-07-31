# Dart

To install the Dart SDK, add `dart` to `environment.systemPackages`, or bring it
into scope with `nix-shell -p dart`. This allows the `dart` and `pub` commands
to be used on a Dart project without needing to write a Nix expression.

## Packaging Dart applications

Nixpkgs provides the `buildDartPackage` function as a convenience for building
Dart projects using the [standard source
layout](https://dart.dev/tools/pub/package-layout). For example, see the
expression for building `dart-sass`:

```nix
{ stdenv, fetchFromGitHub, buildDartPackage }:

buildDartPackage rec {
  pname = "dart-sass";
  version = "1.26.10";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    sha256 = "0qnqjd1ny8cm0jzd9fjacf12628ilc7py9p0fziww0d6n70cgrr0";
  };

  pubspecLock = ./pubspec.lock;
  pubSha256 = "00n9vawlzb57m1m00f6hn0xd0mka80bbygid77rj2k1cd5glwvzp";

  executables = {
    dart-sass = "sass";
    sass = "sass";
  };

  meta = with stdenv.lib; {
    description = "The reference implementation of Sass, written in Dart.";
    homepage = "https://sass-lang.com/dart-sass";
    maintainers = [ maintainers.tadfisher ];
  };
}
```

### Lockfiles and dependencies

`buildDartPackage` requires a `pubspec.lock` file to be present in `$sourceRoot`
in order to fetch dependencies. If the source does not provide this file, as is
the case with many library projects, generate it using `pub get` and include the
path to the resulting `pubspec.lock` file in the `pubspecLock` attribute.

Note that `pubspec.lock` is compared before and after the derivation's
`patchPhase`, so modifications to this file—such as the use of `pub upgrade`—
will cause the build to fail.

To ensure the build is reproducible, `buildDartPackage` also requires the
`pubSha256` attribute if resolving dependencies with `pub get`. To obtain this
value, set `pubSha256` to `stdenv.lib.fakeSha256`, build the package, and copy
the value from the error output. The following output shows the value of
`pubSha256` for the `dart-sass` expression:

```
hash mismatch in fixed-output derivation '/nix/store/cxp6qmnf48v0j51lwj1l6v2kwy6sjds7-dart-sass-deps-1.26.10':
  wanted: sha256:0000000000000000000000000000000000000000000000000000
  got:    sha256:00n9vawlzb57m1m00f6hn0xd0mka80bbygid77rj2k1cd5glwvzp
     (copy this: ^--------------------------------------------------^)
```

If manually including dependencies in the source, such as by copying the
contents of `$HOME/.pub-cache` to quickly build a Dart project in Nix, set
`pubCacheDir` to a store path or a relative path to `$sourceRoot`:

```nix
pubCacheDir = ~/.pub-cache;
# or
pubCacheDir = "path/to/included/cache";
```

In this case, `pubSha256` is not required.

### Executables

Currently, `buildDartPackage` only supports building snapshots of executable
Dart commands, which reside in the `bin/` directory of the project. These must
be specified in the `executables` attribute, which mirrors the format used in
`pubspec.yaml`. Each attribute name is the name of the resulting wrapper
script in `$out/bin`, and each attribute value is the relative path to the
Dart source in `$sourceRoot/bin`, excluding the `.dart` filename suffix.

For example, the `executables` entry in the `pubspec.yaml` file for `dart-sass`

```yaml
executables:
  dart-sass: sass
  sass: sass
```

...becomes the following value for `executables` in the Nix expression:

```nix
executables = {
  dart-sass = "sass";
  sass = "sass";
};
```

Note that in this case, two wrapper scripts are generate in `$out/bin`, both of
which execute the same Dart snapshot.

### Debug build

By default, `buildDartPackage` compiles snapshots in "release" mode, which
disables assertions. To build the package in "debug" mode, pass the `buildType`
attribute with the string `"debug"`:

```nix
buildType = "debug";
```

### Build flags

Pass additional flags to the `dart` command with `dartFlags`. For example:

```nix
dartFlags = [ "-DcustomFlag=value" "--snapshot-kind=app-jit" ];
```

Note that the `--snapshot-kind=app-jit` flag as shown will restrict the
resulting package to run on the same host architecture as the build machine, as
Dart does not support cross-compilation. `buildDartPackage` does not verify this
case, which is why it creates `kernel` snapshots which may be used on any host.
