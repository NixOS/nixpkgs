# File set library

The main goal of the file set library is to be able to select local files that should be added to the Nix store.
It should have the following properties:
- Easy:
  The functions should have obvious semantics, be low in number and be composable.
- Safe:
  Throw early and helpful errors when mistakes are detected.
- Lazy:
  Only compute values when necessary.

Non-goals are:
- Efficient:
  If the abstraction proves itself worthwhile but too slow, it can be still be optimized further.

## Tests

Tests are declared in [`tests.sh`](./tests.sh) and can be run using
```
./tests.sh
```

## Benchmark

A simple benchmark against the HEAD commit can be run using
```
./benchmark.sh HEAD
```

This is intended to be run manually and is not checked by CI.

## Internal representation

The internal representation is versioned in order to allow file sets from different Nixpkgs versions to be composed with each other, see [`internal.nix`](./internal.nix) for the versions and conversions between them.
This section describes only the current representation, but past versions will have to be supported by the code.

### `fileset`

An attribute set with these values:

- `_type` (constant string `"fileset"`):
  Tag to indicate this value is a file set.

- `_internalVersion` (constant string equal to the current version):
  Version of the representation

- `_internalBase` (path):
  Any files outside of this path cannot influence the set of files.
  This is always a directory.

- `_internalTree` ([filesetTree](#filesettree)):
  A tree representation of all included files under `_internalBase`.

- `__noEval` (error):
  An error indicating that directly evaluating file sets is not supported.

## `filesetTree`

One of the following:

- `{ <name> = filesetTree; }`:
  A directory with a nested `filesetTree` value for every directory entry.
  Even entries that aren't included are present as `null` because it improves laziness and allows using this as a sort of `builtins.readDir` cache.

- `"directory"`:
  A directory with all its files included recursively, allowing early cutoff for some operations.
  This specific string is chosen to be compatible with `builtins.readDir` for a simpler implementation.

- `"regular"`, `"symlink"`, `"unknown"` or any other non-`"directory"` string:
  A nested file with its file type.
  These specific strings are chosen to be compatible with `builtins.readDir` for a simpler implementation.
  Distinguishing between different file types is not strictly necessary for the functionality this library,
  but it does allow nicer printing of file sets.

- `null`:
  A file or directory that is excluded from the tree.
  It may still exist on the file system.

## API design decisions

This section justifies API design decisions.

### Internal structure

The representation of the file set data type is internal and can be changed over time.

Arguments:
- (+) The point of this library is to provide high-level functions, users don't need to be concerned with how it's implemented
- (+) It allows adjustments to the representation, which is especially useful in the early days of the library.
- (+) It still allows the representation to be stabilized later if necessary and if it has proven itself

### Influence tracking

File set operations internally track the top-most directory that could influence the exact contents of a file set.
Specifically, `toSource` requires that the given `fileset` is completely determined by files within the directory specified by the `root` argument.
For example, even with `dir/file.txt` being the only file in `./.`, `toSource { root = ./dir; fileset = ./.; }` gives an error.
This is because `fileset` may as well be the result of filtering `./.` in a way that excludes `dir`.

Arguments:
- (+) This gives us the guarantee that adding new files to a project never breaks a file set expression.
  This is also true in a lesser form for removed files:
  only removing files explicitly referenced by paths can break a file set expression.
- (+) This can be removed later, if we discover it's too restrictive
- (-) It leads to errors when a sensible result could sometimes be returned, such as in the above example.

### Empty directories

File sets can only represent a _set_ of local files, directories on their own are not representable.

Arguments:
- (+) There does not seem to be a sensible set of combinators when directories can be represented on their own.
  Here's some possibilities:
  - `./.` represents the files in `./.` _and_ the directory itself including its subdirectories, meaning that even if there's no files, the entire structure of `./.` is preserved

    In that case, what should `fileFilter (file: false) ./.` return?
    It could return the entire directory structure unchanged, but with all files removed, which would not be what one would expect.

    Trying to have a filter function that also supports directories will lead to the question of:
    What should the behavior be if `./foo` itself is excluded but all of its contents are included?
    It leads to having to define when directories are recursed into, but then we're effectively back at how the `builtins.path`-based filters work.

  - `./.` represents all files in `./.` _and_ the directory itself, but not its subdirectories, meaning that at least `./.` will be preserved even if it's empty.

    In that case, `intersect ./. ./foo` should only include files and no directories themselves, since `./.` includes only `./.` as a directory, and same for `./foo`, so there's no overlap in directories.
    But intuitively this operation should result in the same as `./foo` – everything else is just confusing.
- (+) This matches how Git only supports files, so developers should already be used to it.
- (-) Empty directories (even if they contain nested directories) are neither representable nor preserved when coercing from paths.
  - (+) It is very rare that empty directories are necessary.
  - (+) We can implement a workaround, allowing `toSource` to take an extra argument for ensuring certain extra directories exist in the result.
- (-) It slows down store imports, since the evaluator needs to traverse the entire tree to remove any empty directories
  - (+) This can still be optimized by introducing more Nix builtins if necessary

### String paths

File sets do not support Nix store paths in strings such as `"/nix/store/...-source"`.

Arguments:
- (+) Such paths are usually produced by derivations, which means `toSource` would either:
  - Require IFD if `builtins.path` is used as the underlying primitive
  - Require importing the entire `root` into the store such that derivations can be used to do the filtering
- (+) The convenient path coercion like `union ./foo ./bar` wouldn't work for absolute paths, requiring more verbose alternate interfaces:
  - `let root = "/nix/store/...-source"; in union "${root}/foo" "${root}/bar"`

    Verbose and dangerous because if `root` was a path, the entire path would get imported into the store.

  - `toSource { root = "/nix/store/...-source"; fileset = union "./foo" "./bar"; }`

    Does not allow debug printing intermediate file set contents, since we don't know the paths contents before having a `root`.

  - `let fs = lib.fileset.withRoot "/nix/store/...-source"; in fs.union "./foo" "./bar"`

    Makes library functions impure since they depend on the contextual root path, questionable composability.

- (+) The point of the file set abstraction is to specify which files should get imported into the store.

  This use case makes little sense for files that are already in the store.
  This should be a separate abstraction as e.g. `pkgs.drvLayout` instead, which could have a similar interface but be specific to derivations.
  Additional capabilities could be supported that can't be done at evaluation time, such as renaming files, creating new directories, setting executable bits, etc.

### Single files

File sets cannot add single files to the store, they can only import files under directories.

Arguments:
- (+) There's no point in using this library for a single file, since you can't do anything other than add it to the store or not.
  And it would be unclear how the library should behave if the one file wouldn't be added to the store:
  `toSource { root = ./file.nix; fileset = <empty>; }` has no reasonable result because returing an empty store path wouldn't match the file type, and there's no way to have an empty file store path, whatever that would mean.

## To update in the future

Here's a list of places in the library that need to be updated in the future:
- > The file set library is currently very limited but is being expanded to include more functions over time.

  in [the manual](../../doc/functions/fileset.section.md)
- > Currently the only way to construct file sets is using implicit coercion from paths.

  in [the `toSource` reference](./default.nix)
- > For now filesets are always paths

  in [the `toSource` implementation](./default.nix), also update the variable name there
- Once a tracing function exists, `__noEval` in [internal.nix](./internal.nix) should mention it
- If/Once a function to convert `lib.sources` values into file sets exists, the `_coerce` and `toSource` functions should be updated to mention that function in the error when such a value is passed
- If/Once a function exists that can optionally include a path depending on whether it exists, the error message for the path not existing in `_coerce` should mention the new function
