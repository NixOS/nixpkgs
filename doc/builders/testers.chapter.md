# Testers {#chap-testers}
This chapter describes several testing builders which are available in the <literal>testers</literal> namespace.

## `testVersion` {#tester-testVersion}

Checks the command output contains the specified version

Although simplistic, this test assures that the main program
can run. While there's no substitute for a real test case,
it does catch dynamic linking errors and such. It also provides
some protection against accidentally building the wrong version,
for example when using an 'old' hash in a fixed-output derivation.

Examples:

```nix
passthru.tests.version = testers.testVersion { package = hello; };

passthru.tests.version = testers.testVersion {
  package = seaweedfs;
  command = "weed version";
};

passthru.tests.version = testers.testVersion {
  package = key;
  command = "KeY --help";
  # Wrong '2.5' version in the code. Drop on next version.
  version = "2.5";
};

passthru.tests.version = testers.testVersion {
  package = ghr;
  # The output needs to contain the 'version' string without any prefix or suffix.
  version = "v${version}";
};
```

## `testBuildFailure` {#tester-testBuildFailure}

Make sure that a build does not succeed. This is useful for testing testers.

This returns a derivation with an override on the builder, with the following effects:

 - Fail the build when the original builder succeeds
 - Move `$out` to `$out/result`, if it exists (assuming `out` is the default output)
 - Save the build log to `$out/testBuildFailure.log` (same)

Example:

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

While `testBuildFailure` is designed to keep changes to the original builder's
environment to a minimum, some small changes are inevitable.

 - The file `$TMPDIR/testBuildFailure.log` is present. It should not be deleted.
 - `stdout` and `stderr` are a pipe instead of a tty. This could be improved.
 - One or two extra processes are present in the sandbox during the original
   builder's execution.
 - The derivation and output hashes are different, but not unusual.
 - The derivation includes a dependency on `buildPackages.bash` and
   `expect-failure.sh`, which is built to include a transitive dependency on
   `buildPackages.coreutils` and possibly more. These are not added to `PATH`
   or any other environment variable, so they should be hard to observe.

## `testEqualContents` {#tester-equalContents}

Check that two paths have the same contents.

Example:

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

## `testEqualDerivation` {#tester-testEqualDerivation}

Checks that two packages produce the exact same build instructions.

This can be used to make sure that a certain difference of configuration,
such as the presence of an overlay does not cause a cache miss.

When the derivations are equal, the return value is an empty file.
Otherwise, the build log explains the difference via `nix-diff`.

Example:

```nix
testers.testEqualDerivation
  "The hello package must stay the same when enabling checks."
  hello
  (hello.overrideAttrs(o: { doCheck = true; }))
```

## `invalidateFetcherByDrvHash` {#tester-invalidateFetcherByDrvHash}

Use the derivation hash to invalidate the output via name, for testing.

Type: `(a@{ name, ... } -> Derivation) -> a -> Derivation`

Normally, fixed output derivations can and should be cached by their output
hash only, but for testing we want to re-fetch everytime the fetcher changes.

Changes to the fetcher become apparent in the drvPath, which is a hash of
how to fetch, rather than a fixed store path.
By inserting this hash into the name, we can make sure to re-run the fetcher
every time the fetcher changes.

This relies on the assumption that Nix isn't clever enough to reuse its
database of local store contents to optimize fetching.

You might notice that the "salted" name derives from the normal invocation,
not the final derivation. `invalidateFetcherByDrvHash` has to invoke the fetcher
function twice: once to get a derivation hash, and again to produce the final
fixed output derivation.

Example:

```nix
tests.fetchgit = testers.invalidateFetcherByDrvHash fetchgit {
  name = "nix-source";
  url = "https://github.com/NixOS/nix";
  rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
  hash = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
};
```

## `nixosTest` {#tester-nixosTest}

Run a NixOS VM network test using this evaluation of Nixpkgs.

NOTE: This function is primarily for external use. NixOS itself uses `make-test-python.nix` directly. Packages defined in Nixpkgs [reuse NixOS tests via `nixosTests`, plural](#ssec-nixos-tests-linking).

It is mostly equivalent to the function `import ./make-test-python.nix` from the
[NixOS manual](https://nixos.org/nixos/manual/index.html#sec-nixos-tests),
except that the current application of Nixpkgs (`pkgs`) will be used, instead of
letting NixOS invoke Nixpkgs anew.

If a test machine needs to set NixOS options under `nixpkgs`, it must set only the
`nixpkgs.pkgs` option.

### Parameter

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

### Result

A derivation that runs the VM test.

Notable attributes:

 * `nodes`: the evaluated NixOS configurations. Useful for debugging and exploring the configuration.

 * `driverInteractive`: a script that launches an interactive Python session in the context of the `testScript`.
