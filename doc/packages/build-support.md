# Build Support {#sec-build-support}

## `pkgs.substitute` {#pkgs-substitute}

`pkgs.substitute` is a wrapper around [the `substitute` Bash function](#fun-substitute) in the standard environment.
It replaces strings in `src` as specified by the `substitutions` argument.


:::{.example #ex-pkgs-substitute}
# Usage of `pkgs.substitute`

In a build script, the line:

```bash
substitute $infile $outfile --replace-fail @foo@ ${foopkg}/bin/foo
```

is equivalent to:

```nix
{ substitute, foopkg }:
substitute {
  src = ./sourcefile.txt;
  substitutions = [
    "--replace"
    "@foo@"
    "${foopkg}/bin/foo"
  ];
}
```
:::

## `pkgs.substituteAll` {#pkgs-substituteall}

`pkgs.substituteAll` substitutes all instances of `@varName@` (`@`s included) in file `src` with the value of the corresponding environment variable.
As this uses the [`substituteAll`] (#fun-substitute) function, its limitations regarding variable names that will or will not be replaced also apply here.

:::{.example #ex-pkgs-substituteAll}
# Usage of `pkgs.substituteAll`

If `say-goodbye.sh` contains the following:

```bash
#! @bash@/bin/bash

echo @unchanged@
@hello@/bin/hello --greeting @greeting@
```

the following derivation will make substitutions to `@bash@`, `@hello@`, and `@greeting@`:

```nix
{
  substituteAll,
  bash,
  hello,
}:
substituteAll {
  src = ./say-goodbye.sh;
  env = {
    inherit bash hello;
    greeting = "goodbye";
  };
}
```

such that `$out` will result in something like the following:

```
#! /nix/store/s30jrpgav677fpc9yvkqsib70xfmx7xi-bash-5.2p26/bin/bash

echo @unchanged@
/nix/store/566f5isbvw014h7knmzmxa5l6hshx43k-hello-2.12.1/bin/hello --greeting goodbye
```
:::

## `pkgs.substituteAllFiles` {#pkgs-substituteallfiles}

`pkgs.substituteAllFiles` replaces `@varName@` with the value of the environment variable `varName`.
It expects `src` to be a directory and requires a `files` argument that specifies which files will be subject to replacements; only these files will be placed in `$out`.

As it also uses the `substituteAll` function, it is subject to the same limitations on environment variables as discussed in [pkgs.substituteAll](#pkgs-substituteall).

:::{.example #ex-pkgs-substitute-all-files}
# Usage of `pkgs.substituteAllFiles`

If the current directory contains `{foo,bar,baz}.txt` and the following `default.nix`

```nix
{ substituteAllFiles }:
substituteAllFiles {
  src = ./.;
  files = [
    "foo.txt"
    "bar.txt"
  ];
  hello = "there";
}
```

in the resulting derivation, every instance of `@hello@` will be replaced with `there` in `$out/foo.txt` and` `$out/bar.txt`; `baz.txt` will not be processed nor will it appear in `$out`.
:::
