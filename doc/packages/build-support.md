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

## `pkgs.nukeReferences` {#pkgs-nukereferences}

`nuke-refs` replaces unwanted Nix store references in a file.

:::{.example #ex-pkgs-nuke-references}
# Usage of `pkgs.nukeReferences`

```nix
{
  stdenv,
  nukeReferences,
  libfoo,
  libbar,
}:
stdenv.mkDerivation {
  pname = "baz";
  version = "1.0";
  src = ./src;

  nativeBuildInputs = [
    nukeReferences
    libfoo
  ];
  buildInputs = [ libbar ];

  postFixup = ''
    nuke-refs -e "$out" -e "${libbar}" "$out/lib/baz.so"
  '';
}
```

- `$out/lib/baz.so` links against `libbar`, so `libbar` is still needed at runtime.
- `libfoo` was only needed at buildtime to build `baz.so`, but its path ended up embedded anyway.
- `baz.so` also has its own install path, `$out/share/baz`, compiled in as a data directory, which is an intentional self-reference.
- `-e "${libbar}"` keeps all `libbar` references.
- `-e "$out"` keeps that self-reference to `$out`.

`nuke-refs` replaces the `libfoo` reference, along with any other unwanted store path reference embedded in `$out/lib/baz.so`.
For example:

```
/nix/store/lxra5fkapsdbdjqi6wa205s7vmqh1vxb-libfoo-1.2.3/lib/libfoo.so -> /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-libfoo-1.2.3/lib/libfoo.so
```
:::

[Nix scans all outputs for Nix store references, and registers them as runtime dependencies](https://nix.dev/manual/nix/stable/store/building.html#processing-outputs).
Any reference left behind by a build tool, e.g. a compiler path embedded in a generated file, can therefore pull in a much larger closure than intended.
Such references might even fail the build outright if it forms a reference cycle or violates [`disallowedReferences`](https://nix.dev/manual/nix/stable/language/advanced-attributes.html#adv-attr-disallowedReferences).

`nuke-refs [-e <path>]... file...` replaces unwanted references in each `file` in place.
Pass one or more `-e path` arguments to keep certain store paths from being replaced.

::: {.note}
`nuke-refs` replaces the hash of each store path with `eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee`.

`-e` only matches on the hash, not the derivation name.
If you pass `-e /nix/store/<hash>-foo`, `nuke-refs` also keeps `/nix/store/<hash>-bar`.
:::
