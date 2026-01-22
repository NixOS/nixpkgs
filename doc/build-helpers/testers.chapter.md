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
{
  passthru.tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };

  meta.pkgConfigModules = [ "libfoo" ];
}
```

:::

:::{.example #ex-haspkgconfigmodules-explicitmodules}

# Check that `pkg-config` modules are exposed using explicit module names

```nix
{
  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "libfoo" ];
  };
}
```

:::

## `hasCmakeConfigModules` {#tester-hasCmakeConfigModules}

Checks whether a package exposes a given list of `*config.cmake` modules.
Note the moduleNames used in cmake find_package are case sensitive.

:::{.example #ex-hascmakeconfigmodules}

# Check that `*config.cmake` modules are exposed using explicit module names

```nix
{
  passthru.tests.cmake-config = testers.hasCmakeConfigModules {
    package = finalAttrs.finalPackage;
    moduleNames = [ "Foo" ];
  };
}
```

:::

## `lycheeLinkCheck` {#tester-lycheeLinkCheck}

Check a packaged static site's links with the [`lychee` package](https://search.nixos.org/packages?show=lychee&type=packages&query=lychee).

You may use Nix to reproducibly build static websites, such as for software documentation.
Some packages will install documentation in their `out` or `doc` outputs, or maybe you have dedicated package where you've made your static site reproducible by running a generator, such as [Hugo](https://gohugo.io/) or [mdBook](https://rust-lang.github.io/mdBook/), in a derivation.

If you have a static site that can be built with Nix, you can use `lycheeLinkCheck` to check that the hyperlinks in your site are correct, and do so as part of your Nix workflow and CI.

:::{.example #ex-lycheelinkcheck}

# Check hyperlinks in the `nix` documentation

```nix
testers.lycheeLinkCheck { site = nix.doc + "/share/doc/nix/manual"; }
```

:::

### Return value {#tester-lycheeLinkCheck-return}

This tester produces a package that does not produce useful outputs, but only succeeds if the hyperlinks in your site are correct. The build log will list the broken links.

It has two modes:

- Build the returned derivation; its build process will check that internal hyperlinks are correct. This runs in the sandbox, so it will not check external hyperlinks, but it is quick and reliable.

- Invoke the `.online` attribute with [`nix run`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run) ([experimental](https://nixos.org/manual/nix/stable/contributing/experimental-features#xp-feature-nix-command)). This runs outside the sandbox, and checks that both internal and external hyperlinks are correct.
  Example:

  ```shell
  nix run nixpkgs#lychee.tests.ok.online
  ```

### Inputs {#tester-lycheeLinkCheck-inputs}

`site` (path or derivation) {#tester-lycheeLinkCheck-param-site}

: The path to the files to check.

`remap` (attribute set, optional) {#tester-lycheeLinkCheck-param-remap}

: An attribute set where the attribute names are regular expressions.
  The values should be strings, derivations, or path values.

  In the returned check's default configuration, external URLs are only checked when you run the `.online` attribute.

  By adding remappings, you can check offline that URLs to external resources are correct, by providing a stand-in from the file system.

  Before checking the existence of a URL, the regular expressions are matched and replaced by their corresponding values.

  Example:

  ```nix
  {
    "https://nix\\.dev/manual/nix/[a-z0-9.-]*" = "${nix.doc}/share/doc/nix/manual";
    "https://nixos\\.org/manual/nix/(un)?stable" =
      "${emptyDirectory}/placeholder-to-disallow-old-nix-docs-urls";
  }
  ```

  Store paths in the attribute values are automatically prefixed with `file://`, because lychee requires this for paths in the file system.
  If this is a problem, or if you need to control the order in which replacements are performed, use `extraConfig.remap` instead.

`extraConfig` (attribute set) {#tester-lycheeLinkCheck-param-extraConfig}

: Extra configuration to pass to `lychee` in its [configuration file](https://github.com/lycheeverse/lychee/blob/master/lychee.example.toml).
  It is automatically [translated](https://nixos.org/manual/nixos/stable/index.html#sec-settings-nix-representable) to TOML.

  Example: `{ "include_verbatim" = true; }`

`lychee` (derivation, optional) {#tester-lycheeLinkCheck-param-lychee}

: The `lychee` package to use.

## `shellcheck` {#tester-shellcheck}

Run files through `shellcheck`, a static analysis tool for shell scripts, failing if there are any issues.

:::{.example #ex-shellcheck}
# Run `testers.shellcheck`

A single script

```nix
testers.shellcheck {
  name = "script";
  src = ./script.sh;
}
```

Multiple files

```nix
let
  inherit (lib) fileset;
in
testers.shellcheck {
  name = "nixbsd-activate";
  src = fileset.toSource {
    root = ./.;
    fileset = fileset.unions [
      ./lib.sh
      ./nixbsd-activate
    ];
  };
}
```

:::

### Inputs {#tester-shellcheck-inputs}

`name` (string, optional)
: The name of the test.
  `name` will be required at a future point because it massively improves traceability of test failures, but is kept optional for now to avoid breaking existing usages.
  Defaults to `run-shellcheck`.
  The name of the derivation produced by the tester is `shellcheck-${name}` when `name` is supplied.

`src` (path-like)
: The path to the shell script(s) to check.
  This can be a single file or a directory containing shell files.
  All files in `src` will be checked, so you may want to provide `fileset`-based source instead of a whole directory.

### Return value {#tester-shellcheck-return}

A derivation that runs `shellcheck` on the given script(s), producing an empty output if no issues are found.
The build will fail if `shellcheck` finds any issues.

## `shfmt` {#tester-shfmt}

Run files through `shfmt`, a shell script formatter, failing if any files are reformatted.

:::{.example #ex-shfmt}
# Run `testers.shfmt`

A single script

```nix
testers.shfmt {
  name = "script";
  src = ./script.sh;
}
```

Multiple files

```nix
let
  inherit (lib) fileset;
in
testers.shfmt {
  name = "nixbsd";
  src = fileset.toSource {
    root = ./.;
    fileset = fileset.unions [
      ./lib.sh
      ./nixbsd-activate
    ];
  };
}
```

:::

### Inputs {#tester-shfmt-inputs}

`name` (string)
: The name of the test.
  `name` is required because it massively improves traceability of test failures.
  The name of the derivation produced by the tester is `shfmt-${name}`.

`src` (path-like)
: The path to the shell script(s) to check.
  This can be a single file or a directory containing shell files.
  All files in `src` will be checked, so you may want to provide `fileset`-based source instead of a whole directory.

`indent` (integer, optional)
: The number of spaces to use for indentation.
  Defaults to `2`.
  A value of `0` indents with tabs.

### Return value {#tester-shfmt-return}

A derivation that runs `shfmt` on the given script(s), producing an empty output upon success.
The build will fail if `shfmt` reformats anything.

## `testVersion` {#tester-testVersion}

Checks that the output from running a command contains the specified version string in it as a whole word.

NOTE: This is a check you add to `passthru.tests` which is mainly run by OfBorg, but not in Hydra. If you want a version check failure to block the build altogether, then [`versionCheckHook`](#versioncheckhook) is the tool you're looking for (and recommended for quick builds). The motivation for adding either of these checks would be:

- Catch dynamic linking errors and such and missing environment variables that should be added by wrapping.
- Probable protection against accidentally building the wrong version, for example when using an "old" hash in a fixed-output derivation.

By default, the command to be run will be inferred from the given `package` attribute:
it will check `meta.mainProgram` first, and fall back to `pname` or `name`.
The default argument to the command is `--version`, and the version to be checked will be inferred from the given `package` attribute as well.

:::{.example #ex-testversion-hello}

# Check a program version using all the default values

This example will run the command `hello --version`, and then check that the version of the `hello` package is in the output of the command.

```nix
{ passthru.tests.version = testers.testVersion { package = hello; }; }
```

:::

:::{.example #ex-testversion-different-commandversion}

# Check the program version using a specified command and expected version string

This example will run the command `leetcode -V`, and then check that `leetcode 0.4.2` is in the output of the command as a whole word (separated by whitespaces).
This means that an output like "leetcode 0.4.21" would fail the tests, and an output like "You're running leetcode 0.4.2" would pass the tests.

A common usage of the `version` attribute is to specify `version = "v${version}"`.

```nix
{
  version = "0.4.2";

  passthru.tests.version = testers.testVersion {
    package = leetcode-cli;
    command = "leetcode -V";
    version = "leetcode ${version}";
  };
}
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
runCommand "example"
  {
    failed = testers.testBuildFailure (
      runCommand "fail" { } ''
        echo ok-ish >$out
        echo failing though
        exit 3
      ''
    );
  }
  ''
    grep -F 'ok-ish' $failed/result
    grep -F 'failing though' $failed/testBuildFailure.log
    [[ 3 = $(cat $failed/testBuildFailure.exit) ]]
    touch $out
  ''
```

:::

## `testBuildFailure'` {#tester-testBuildFailurePrime}

This tester wraps the functionality provided by [`testers.testBuildFailure`](#tester-testBuildFailure) to make writing checks easier by simplifying checking the exit code of the builder and asserting the existence of entries in the builder's log.
Additionally, users may specify a script containing additional checks, accessing the result of applying `testers.testBuildFailure` through the variable `failed`.

NOTE: This tester will produce an empty output and exit with success if none of the checks fail; there is no need to `touch "$out"` in `script`.

:::{.example #ex-testBuildFailurePrime-doc-example}

# Check that a build fails, and verify the changes made during build

Re-using the example from [`testers.testBuildFailure`](#ex-testBuildFailure-showingenvironmentchanges), we can see how common checks are made easier and remove the need for `runCommand`:

```nix
testers.testBuildFailure' {
  drv = runCommand "doc-example" { } ''
    echo ok-ish >"$out"
    echo failing though
    exit 3
  '';
  expectedBuilderExitCode = 3;
  expectedBuilderLogEntries = [ "failing though" ];
  script = ''
    grep --silent -F 'ok-ish' "$failed/result"
  '';
}
```

:::

### Inputs {#tester-testBuildFailurePrime-inputs}

`drv` (derivation)

: The failing derivation to wrap with `testBuildFailure`.

`name` (string, optional)

: The name of the test.
  When not provided, this value defaults to `testBuildFailure-${(testers.testBuildFailure drv).name}`.

`expectedBuilderExitCode` (integer, optional)

: The expected exit code of the builder of `drv`.
  When not provided, this value defaults to `1`.

`expectedBuilderLogEntries` (array of string-like values, optional)

: A list of string-like values which must be found in the builder's log by exact match.
  When not provided, this value defaults to `[ ]`.

  NOTE: Patterns and regular expressions are not supported.

`script` (string, optional)

: A string containing additional checks to run.
  When not provided, this value defaults to `""`.
  The result of `testers.testBuildFailure drv` is available through the variable `failed`.
  As an example, the builder's log is at `"$failed/testBuildFailure.log"`.

### Return value {#tester-testBuildFailurePrime-return}

The tester produces an empty output and only succeeds when the checks using `expectedBuilderExitCode`, `expectedBuilderLogEntries`, and `script` succeed.

## `testEqualContents` {#tester-testEqualContents}

Check that two paths have the same contents.

`assertion` (string)

: A message that is printed before the comparison, after `Checking:`.

`expected` (path or value coercible to store path)

: The path to the expected [file system object] content

`actual` (value coercible to store path) <!-- path value is possible, but wrong in practice, but let's not bother readers with our predictions -->

: The path to the actual file system object content to check

`postFailureMessage` (string)

: A message that is printed last if the file system object contents at the two paths don't match exactly.

`checkMetadata` (boolean)

: Whether to fail on metadata differences, such as permissions or ownership.
  Defaults to `true`.

:::{.example #ex-testEqualContents-toyexample}

# Check that two paths have the same contents

```nix
testers.testEqualContents {
  assertion = "sed -e performs replacement";
  expected = writeText "expected" ''
    foo baz baz
  '';
  actual =
    runCommand "actual"
      {
        # not really necessary for a package that's in stdenv
        nativeBuildInputs = [ gnused ];
        base = writeText "base" ''
          foo bar baz
        '';
      }
      ''
        sed -e 's/bar/baz/g' $base >$out
      '';
  # if applicable
  postFailureMessage = ''
    The bar-baz replacer produced an unexpected result.
    If the new behavior is acceptable and validated against the bar-baz specification, run ./adopt-new-bar-baz-result.sh to adjust this test and require the new behavior.
  '';
}
```

:::

## `testEqualArrayOrMap` {#tester-testEqualArrayOrMap}

Check that bash arrays (including associative arrays, referred to as "maps") are populated correctly.

This can be used to ensure setup hooks are registered in a certain order, or to write unit tests for shell functions which transform arrays.

:::{.example #ex-testEqualArrayOrMap-test-function-add-cowbell}

# Test a function which appends a value to an array

```nix
testers.testEqualArrayOrMap {
  name = "test-function-add-cowbell";
  valuesArray = [
    "cowbell"
    "cowbell"
  ];
  expectedArray = [
    "cowbell"
    "cowbell"
    "cowbell"
  ];
  script = ''
    addCowbell() {
      local -rn arrayNameRef="$1"
      arrayNameRef+=( "cowbell" )
    }

    nixLog "appending all values in valuesArray to actualArray"
    for value in "''${valuesArray[@]}"; do
      actualArray+=( "$value" )
    done

    nixLog "applying addCowbell"
    addCowbell actualArray
  '';
}
```

:::

### Inputs {#tester-testEqualArrayOrMap-inputs}

NOTE: Internally, this tester uses `__structuredAttrs` to handle marshalling between Nix expressions and shell variables.
This imposes the restriction that arrays and "maps" have values which are string-like.

NOTE: At least one of `expectedArray` and `expectedMap` must be provided.

`name` (string)

: The name of the test.

`script` (string)

: The singular task of `script` is to populate `actualArray` or `actualMap` (it may populate both).
  To do this, `script` may access the following shell variables:

  - `valuesArray` (available when `valuesArray` is provided to the tester)
  - `valuesMap` (available when `valuesMap` is provided to the tester)
  - `actualArray` (available when `expectedArray` is provided to the tester)
  - `actualMap` (available when `expectedMap` is provided to the tester)

  While both `expectedArray` and `expectedMap` are in scope during the execution of `script`, they *must not* be accessed or modified from within `script`.

`valuesArray` (array of string-like values, optional)

: An array of string-like values.
  This array may be used within `script`.

`valuesMap` (attribute set of string-like values, optional)

: An attribute set of string-like values.
  This attribute set may be used within `script`.

`expectedArray` (array of string-like values, optional)

: An array of string-like values.
  This array *must not* be accessed or modified from within `script`.
  When provided, `script` is expected to populate `actualArray`.

`expectedMap` (attribute set of string-like values, optional)

: An attribute set of string-like values.
  This attribute set *must not* be accessed or modified from within `script`.
  When provided, `script` is expected to populate `actualMap`.

### Return value {#tester-testEqualArrayOrMap-return}

The tester produces an empty output and only succeeds when `expectedArray` and `expectedMap` match `actualArray` and `actualMap`, respectively, when non-null.
The build log will contain differences encountered.

## `testEqualDerivation` {#tester-testEqualDerivation}

Checks that two packages produce the exact same build instructions.

This can be used to make sure that a certain difference of configuration, such as the presence of an overlay does not cause a cache miss.

When the derivations are equal, the return value is an empty file.
Otherwise, the build log explains the difference via `nix-diff`.

:::{.example #ex-testEqualDerivation-hello}

# Check that two packages produce the same derivation

```nix
testers.testEqualDerivation "The hello package must stay the same when enabling checks." hello (
  hello.overrideAttrs (o: {
    doCheck = true;
  })
)
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
{
  tests.fetchgit = testers.invalidateFetcherByDrvHash fetchgit {
    name = "nix-source";
    url = "https://github.com/NixOS/nix";
    rev = "9d9dbe6ed05854e03811c361a3380e09183f4f4a";
    hash = "sha256-7DszvbCNTjpzGRmpIVAWXk20P0/XTrWZ79KSOGLrUWY=";
  };
}
```

:::

## `runCommand` {#tester-runCommand}

`runCommand :: { name, script, stdenv ? stdenvNoCC, hash ? "...", ... } -> Derivation`

This is a wrapper around `pkgs.runCommandWith`, which
- produces a fixed-output derivation, enabling the command(s) to access the network ;
- salts the derivation's name based on its inputs, ensuring the command is re-run whenever the inputs change.

It accepts the following attributes:
- the derivation's `name` ;
- the `script` to be executed ;
- `stdenv`, the environment to use, defaulting to `stdenvNoCC` ;
- the derivation's output `hash`, defaulting to the empty file's.
  The derivation's `outputHashMode` is set by default to recursive, so the `script` can output a directory as well.

All other attributes are passed through to [`mkDerivation`](#sec-using-stdenv),
including `nativeBuildInputs` to specify dependencies available to the `script`.

:::{.example #ex-tester-runCommand-nix}

# Run a command with network access

```nix
testers.runCommand {
  name = "access-the-internet";
  script = ''
    curl -o /dev/null https://example.com
    touch $out
  '';
  nativeBuildInputs = with pkgs; [
    cacert
    curl
  ];
}
```

:::

## `runNixOSTest` {#tester-runNixOSTest}

A helper function that behaves exactly like the NixOS `runTest`, except it also assigns this Nixpkgs package set as the `pkgs` of the test and makes the `nixpkgs.*` options read-only.

If your test is part of the Nixpkgs repository, or if you need a more general entrypoint, see ["Calling a test" in the NixOS manual](https://nixos.org/manual/nixos/stable/index.html#sec-calling-nixos-tests).

:::{.example #ex-runNixOSTest-hello}

# Run a NixOS test using `runNixOSTest`

```nix
pkgs.testers.runNixOSTest (
  { lib, ... }:
  {
    name = "hello";
    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.hello ];
      };
    testScript = ''
      machine.succeed("hello")
    '';
  }
)
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
    machine1 =
      {
        lib,
        pkgs,
        nodes,
        ...
      }:
      {
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

[file system object]: https://nix.dev/manual/nix/latest/store/file-system-object
