# Testers {#chap-testers}

This chapter describes several testing builders which are available in the `testers` namespace.

## `hasPkgConfigModules` {#tester-hasPkgConfigModules}

<!-- Old anchor name so links still work -->
[]{#tester-hasPkgConfigModule}
Checks whether a package exposes a given list of `pkg-config` modules.
If the `moduleNames` argument is omitted, `hasPkgConfigModules` will use `meta.pkgConfigModules`.

:::{.example #ex-haspkgconfigmodules-defaultvalues}

# Check that `pkg-config` modules are exposed using default values

```nix
passthru.tests.pkg-config = testers.hasPkgConfigModules {
  package = finalAttrs.finalPackage;
};

meta.pkgConfigModules = [ "libfoo" ];
```

:::

:::{.example #ex-haspkgconfigmodules-explicitmodules}

# Check that `pkg-config` modules are exposed using explicit module names

```nix
passthru.tests.pkg-config = testers.hasPkgConfigModules {
  package = finalAttrs.finalPackage;
  moduleNames = [ "libfoo" ];
};
```

:::

## `testVersion` {#tester-testVersion}

Checks that the output from running a command contains the specified version string in it as a whole word.

Although simplistic, this test assures that the main program can run.
While there's no substitute for a real test case, it does catch dynamic linking errors and such.
It also provides some protection against accidentally building the wrong version, for example when using an "old" hash in a fixed-output derivation.

By default, the command to be run will be inferred from the given `package` attribute:
it will check `meta.mainProgram` first, and fall back to `pname` or `name`.
The default argument to the command is `--version`, and the version to be checked will be inferred from the given `package` attribute as well.

:::{.example #ex-testversion-hello}

# Check a program version using all the default values

This example will run the command `hello --version`, and then check that the version of the `hello` package is in the output of the command.

```nix
passthru.tests.version = testers.testVersion { package = hello; };
```

:::

:::{.example #ex-testversion-different-commandversion}

# Check the program version using a specified command and expected version string

This example will run the command `leetcode -V`, and then check that `leetcode 0.4.2` is in the output of the command as a whole word (separated by whitespaces).
This means that an output like "leetcode 0.4.21" would fail the tests, and an output like "You're running leetcode 0.4.2" would pass the tests.

A common usage of the `version` attribute is to specify `version = "v${version}"`.

```nix
version = "0.4.2";

passthru.tests.version = testers.testVersion {
  package = leetcode-cli;
  command = "leetcode -V";
  version = "leetcode ${version}";
};
```

:::

## `testBuildFailure` {#tester-testBuildFailure}

Make sure that a build does not succeed. This is useful for testing testers.

This returns a derivation with an override on the builder, with the following effects:

 - Fail the build when the original builder succeeds
 - Move `$out` to `$out/result`, if it exists (assuming `out` is the default output)
 - Save the build log to `$out/testBuildFailure.log` (same)

While `testBuildFailure` is designed to keep changes to the original builder's environment to a minimum, some small changes are inevitable:

 - The file `$TMPDIR/testBuildFailure.log` is present. It should not be deleted.
 - `stdout` and `stderr` are a pipe instead of a tty. This could be improved.
 - One or two extra processes are present in the sandbox during the original builder's execution.
 - The derivation and output hashes are different, but not unusual.
 - The derivation includes a dependency on `buildPackages.bash` and `expect-failure.sh`, which is built to include a transitive dependency on `buildPackages.coreutils` and possibly more.
   These are not added to `PATH` or any other environment variable, so they should be hard to observe.

:::{.example #ex-testBuildFailure-showingenvironmentchanges}

# Check that a build fails, and verify the changes made during build

```nix
runCommand "example" {
  failed = testers.testBuildFailure (runCommand "fail" {} ''
    echo ok-ish >$out
    echo failing though
    exit 3
  '');
} ''
  grep -F 'ok-ish' $failed/result
  grep -F 'failing though' $failed/testBuildFailure.log
  [[ 3 = $(cat $failed/testBuildFailure.exit) ]]
  touch $out
'';
```

:::

## `testEqualContents` {#tester-equalContents}

Check that two paths have the same contents.

:::{.example #ex-testEqualContents-toyexample}

# Check that two paths have the same contents

```nix
testers.testEqualContents {
  assertion = "sed -e performs replacement";
  expected = writeText "expected" ''
    foo baz baz
  '';
  actual = runCommand "actual" {
    # not really necessary for a package that's in stdenv
    nativeBuildInputs = [ gnused ];
    base = writeText "base" ''
      foo bar baz
    '';
  } ''
    sed -e 's/bar/baz/g' $base >$out
  '';
}
```

:::

## `testEqualDerivation` {#tester-testEqualDerivation}

Checks that two packages produce the exact same build instructions.

This can be used to make sure that a certain difference of configuration, such as the presence of an overlay does not cause a cache miss.

When the derivations are equal, the return value is an empty file.
Otherwise, the build log explains the difference via `nix-diff`.

:::{.example #ex-testEqualDerivation-hello}

# Check that two packages produce the same derivation

```nix
testers.testEqualDerivation
  "The hello package must stay the same when enabling checks."
  hello
  (hello.overrideAttrs(o: { doCheck = true; }))
```

:::

## `invalidateFetcherByDrvHash` {#tester-invalidateFetcherByDrvHash}

Use the derivation hash to invalidate the output via name, for testing.

Type: `(a@{ name, ... } -> Derivation) -> a -> Derivation`

Normally, fixed output derivations can and should be cached by their output hash only, but for testing we want to re-fetch everytime the fetcher changes.

Changes to the fetcher become apparent in the drvPath, which is a hash of how to fetch, rather than a fixed store path.
By inserting this hash into the name, we can make sure to re-run the fetcher every time the fetcher changes.

This relies on the assumption that Nix isn't clever enough to reuse its database of local store contents to optimize fetching.

You might notice that the "salted" name derives from the normal invocation, not the final derivation.
`invalidateFetcherByDrvHash` has to invoke the fetcher function twice:
once to get a derivation hash, and again to produce the final fixed output derivation.

:::{.example #ex-invalidateFetcherByDrvHash-nix}

# Prevent nix from reusing the output of a fetcher

```nix
tests.fetchgit = testers.invalidateFetcherByDrvHash fetchgit {
  name = "nix-source";
  url = "https://github.com/NixOS/nix";
  rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
  hash = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
};
```

:::

## `runNixOSTest` {#tester-runNixOSTest}

A helper function that behaves exactly like the NixOS `runTest`, except it also assigns this Nixpkgs package set as the `pkgs` of the test and makes the `nixpkgs.*` options read-only.

If your test is part of the Nixpkgs repository, or if you need a more general entrypoint, see ["Calling a test" in the NixOS manual](https://nixos.org/manual/nixos/stable/index.html#sec-calling-nixos-tests).

:::{.example #ex-runNixOSTest-hello}

# Run a NixOS test using `runNixOSTest`

```nix
pkgs.testers.runNixOSTest ({ lib, ... }: {
  name = "hello";
  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.hello ];
  };
  testScript = ''
    machine.succeed("hello")
  '';
})
```

:::

## `nixosTest` {#tester-nixosTest}

Run a NixOS VM network test using this evaluation of Nixpkgs.

NOTE: This function is primarily for external use. NixOS itself uses `make-test-python.nix` directly. Packages defined in Nixpkgs [reuse NixOS tests via `nixosTests`, plural](#ssec-nixos-tests-linking).

It is mostly equivalent to the function `import ./make-test-python.nix` from the [NixOS manual](https://nixos.org/nixos/manual/index.html#sec-nixos-tests), except that the current application of Nixpkgs (`pkgs`) will be used, instead of letting NixOS invoke Nixpkgs anew.

If a test machine needs to set NixOS options under `nixpkgs`, it must set only the `nixpkgs.pkgs` option.

### Parameter {#tester-nixosTest-parameter}

A [NixOS VM test network](https://nixos.org/nixos/manual/index.html#sec-nixos-tests), or path to it. Example:

```nix
{
  name = "my-test";
  nodes = {
    machine1 = { lib, pkgs, nodes, ... }: {
      environment.systemPackages = [ pkgs.hello ];
      services.foo.enable = true;
    };
    # machine2 = ...;
  };
  testScript = ''
    start_all()
    machine1.wait_for_unit("foo.service")
    machine1.succeed("hello | foo-send")
  '';
}
```

### Result {#tester-nixosTest-result}

A derivation that runs the VM test.

Notable attributes:

 * `nodes`: the evaluated NixOS configurations. Useful for debugging and exploring the configuration.

 * `driverInteractive`: a script that launches an interactive Python session in the context of the `testScript`.
