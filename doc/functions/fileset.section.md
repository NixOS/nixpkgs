<!-- TODO: Render this document in front of function documentation in case https://github.com/nix-community/nixdoc/issues/19 is ever supported -->

# File sets {#sec-fileset}

The [`lib.fileset`](#sec-functions-library-fileset) library allows you to work with _file sets_.
A file set is a mathematical set of local files that can be added to the Nix store for use in Nix derivations.
File sets are easy and safe to use, providing obvious and composable semantics with good error messages to prevent mistakes.

These sections apply to the entire library.
See the [function reference](#sec-functions-library-fileset) for function-specific documentation.

The file set library is currently somewhat limited but is being expanded to include more functions over time.

## Implicit coercion from paths to file sets {#sec-fileset-path-coercion}

All functions accepting file sets as arguments can also accept [paths](https://nixos.org/manual/nix/stable/language/values.html#type-path) as arguments.
Such path arguments are implicitly coerced to file sets containing all files under that path:
- A path to a file turns into a file set containing that single file.
- A path to a directory turns into a file set containing all files _recursively_ in that directory.

If the path points to a non-existent location, an error is thrown.

::: {.note}
Just like in Git, file sets cannot represent empty directories.
Because of this, a path to a directory that contains no files (recursively) will turn into a file set containing no files.
:::

:::{.note}
File set coercion does _not_ add any of the files under the coerced paths to the store.
Only the [`toSource`](#function-library-lib.fileset.toSource) function adds files to the Nix store, and only those files contained in the `fileset` argument.
This is in contrast to using [paths in string interpolation](https://nixos.org/manual/nix/stable/language/values.html#type-path), which does add the entire referenced path to the store.
:::

### Example {#sec-fileset-path-coercion-example}

Assume we are in a local directory with a file hierarchy like this:
```
├─ a/
│  ├─ x (file)
│  └─ b/
│     └─ y (file)
└─ c/
   └─ d/
```

Here's a listing of which files get included when different path expressions get coerced to file sets:
- `./.` as a file set contains both `a/x` and `a/b/y` (`c/` does not contain any files and is therefore omitted).
- `./a` as a file set contains both `a/x` and `a/b/y`.
- `./a/x` as a file set contains only `a/x`.
- `./a/b` as a file set contains only `a/b/y`.
- `./c` as a file set is empty, since neither `c` nor `c/d` contain any files.
