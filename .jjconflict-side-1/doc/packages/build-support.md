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

## `pkgs.replaceVars` {#pkgs-replacevars}

`pkgs.replaceVars <src> <replacements>` replaces all instances of `@varName@` (`@`s included) in file `src` with the respective value in the attribute set `replacements`.

:::{.example #ex-pkgs-replace-vars}
# Usage of `pkgs.replaceVars`

If `say-goodbye.sh` contains the following:

```bash
#! @bash@/bin/bash

echo @unchanged@
@hello@/bin/hello --greeting @greeting@
```

the following derivation will make substitutions to `@bash@`, `@hello@`, and `@greeting@`:

```nix
{
  replaceVars,
  bash,
  hello,
}:
replaceVars ./say-goodbye.sh {
  inherit bash hello;
  greeting = "goodbye";
  unchanged = null;
}
```

such that `$out` will result in something like the following:

```
#! /nix/store/s30jrpgav677fpc9yvkqsib70xfmx7xi-bash-5.2p26/bin/bash

echo @unchanged@
/nix/store/566f5isbvw014h7knmzmxa5l6hshx43k-hello-2.12.1/bin/hello --greeting goodbye
```

Note that, in contrast to the old `substituteAll`, `unchanged = null` must explicitly be set.
Any unreferenced `@...@` pattern in the source file will throw an error.
:::

## `pkgs.replaceVarsWith` {#pkgs-replacevarswith}

`pkgs.replaceVarsWith` works the same way as [pkgs.replaceVars](#pkgs-replacevars), but additionally allows more options.

:::{.example #ex-pkgs-replace-vars-with}
# Usage of `pkgs.replaceVarsWith`

With the example file `say-goodbye.sh`, consider:

```nix
{ replaceVarsWith }:
replaceVarsWith {
  src = ./say-goodbye.sh;

  replacements = {
    inherit bash hello;
    greeting = "goodbye";
    unchanged = null;
  };

  name = "say-goodbye";
  dir = "bin";
  isExecutable = true;
  meta.mainProgram = "say-goodbye";
}
```

This will make the resulting file executable, put it in `bin/say-goodbye` and set `meta` attributes respectively.
:::
