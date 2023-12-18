# File set library

This is the internal contributor documentation.
The user documentation is [in the Nixpkgs manual](https://nixos.org/manual/nixpkgs/unstable/#sec-fileset).

## Goals

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

- `_internalVersion` (constant `3`, the current version):
  Version of the representation.

- `_internalIsEmptyWithoutBase` (bool):
  Whether this file set is the empty file set without a base path.
  If `true`, `_internalBase*` and `_internalTree` are not set.
  This is the only way to represent an empty file set without needing a base path.

  Such a value can be used as the identity element for `union` and the return value of `unions []` and co.

- `_internalBase` (path):
  Any files outside of this path cannot influence the set of files.
  This is always a directory and should be as long as possible.
  This is used by `lib.fileset.toSource` to check that all files are under the `root` argument

- `_internalBaseRoot` (path):
  The filesystem root of `_internalBase`, same as `(lib.path.splitRoot _internalBase).root`.
  This is here because this needs to be computed anyway, and this computation shouldn't be duplicated.

- `_internalBaseComponents` (list of strings):
  The path components of `_internalBase`, same as `lib.path.subpath.components (lib.path.splitRoot _internalBase).subpath`.
  This is here because this needs to be computed anyway, and this computation shouldn't be duplicated.

- `_internalTree` ([filesetTree](#filesettree)):
  A tree representation of all included files under `_internalBase`.

- `__noEval` (error):
  An error indicating that directly evaluating file sets is not supported.

## `filesetTree`

One of the following:

- `{ <name> = filesetTree; }`:
  A directory with a nested `filesetTree` value for directory entries.
  Entries not included may either be omitted or set to `null`, as necessary to improve efficiency or laziness.

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

### Empty file set without a base

There is a special representation for an empty file set without a base path.
This is used for return values that should be empty but when there's no base path that would makes sense.

Arguments:
- Alternative: This could also be represented using `_internalBase = /.` and `_internalTree = null`.
  - (+) Removes the need for a special representation.
  - (-) Due to [influence tracking](#influence-tracking),
    `union empty ./.` would have `/.` as the base path,
    which would then prevent `toSource { root = ./.; fileset = union empty ./.; }` from working,
    which is not as one would expect.
  - (-) With the assumption that there can be multiple filesystem roots (as established with the [path library](../path/README.md)),
    this would have to cause an error with `union empty pathWithAnotherFilesystemRoot`,
    which is not as one would expect.
- Alternative: Do not have such a value and error when it would be needed as a return value
  - (+) Removes the need for a special representation.
  - (-) Leaves us with no identity element for `union` and no reasonable return value for `unions []`.
    From a set theory perspective, which has a well-known notion of empty sets, this is unintuitive.

### No intersection for lists

While there is `intersection a b`, there is no function `intersections [ a b c ]`.

Arguments:
- (+) There is no known use case for such a function, it can be added later if a use case arises
- (+) There is no suitable return value for `intersections [ ]`, see also "Nullary intersections" [here](https://en.wikipedia.org/w/index.php?title=List_of_set_identities_and_relations&oldid=1177174035#Definitions)
  - (-) Could throw an error for that case
  - (-) Create a special value to represent "all the files" and return that
    - (+) Such a value could then not be used with `fileFilter` unless the internal representation is changed considerably
  - (-) Could return the empty file set
    - (+) This would be wrong in set theory
- (-) Inconsistent with `union` and `unions`

### Intersection base path

The base path of the result of an `intersection` is the longest base path of the arguments.
E.g. the base path of `intersection ./foo ./foo/bar` is `./foo/bar`.
Meanwhile `intersection ./foo ./bar` returns the empty file set without a base path.

Arguments:
- Alternative: Use the common prefix of all base paths as the resulting base path
  - (-) This is unnecessarily strict, because the purpose of the base path is to track the directory under which files _could_ be in the file set. It should be as long as possible.
    All files contained in `intersection ./foo ./foo/bar` will be under `./foo/bar` (never just under `./foo`), and `intersection ./foo ./bar` will never contain any files (never under `./.`).
    This would lead to `toSource` having to unexpectedly throw errors for cases such as `toSource { root = ./foo; fileset = intersect ./foo base; }`, where `base` may be `./bar` or `./.`.
  - (-) There is no benefit to the user, since base path is not directly exposed in the interface

### Empty directories

File sets can only represent a _set_ of local files.
Directories on their own are not representable.

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

    In that case, `intersection ./. ./foo` should only include files and no directories themselves, since `./.` includes only `./.` as a directory, and same for `./foo`, so there's no overlap in directories.
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
  - Require [Import From Derivation](https://nixos.org/manual/nix/unstable/language/import-from-derivation) (IFD) if `builtins.path` is used as the underlying primitive
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
- (+) An API for filtering/transforming Nix store paths could be much more powerful,
  because it's not limited to just what is possible at evaluation time with `builtins.path`.
  Operations such as moving and adding files would be supported.

### Single files

File sets cannot add single files to the store, they can only import files under directories.

Arguments:
- (+) There's no point in using this library for a single file, since you can't do anything other than add it to the store or not.
  And it would be unclear how the library should behave if the one file wouldn't be added to the store:
  `toSource { root = ./file.nix; fileset = <empty>; }` has no reasonable result because returing an empty store path wouldn't match the file type, and there's no way to have an empty file store path, whatever that would mean.

### `fileFilter` takes a path

The `fileFilter` function takes a path, and not a file set, as its second argument.

- (-) Makes it harder to compose functions, since the file set type, the return value, can't be passed to the function itself like `fileFilter predicate fileset`
  - (+) It's still possible to use `intersection` to filter on file sets: `intersection fileset (fileFilter predicate ./.)`
    - (-) This does need an extra `./.` argument that's not obvious
      - (+) This could always be `/.` or the project directory, `intersection` will make it lazy
- (+) In the future this will allow `fileFilter` to support a predicate property like `subpath` and/or `components` in a reproducible way.
  This wouldn't be possible if it took a file set, because file sets don't have a predictable absolute path.
  - (-) What about the base path?
    - (+) That can change depending on which files are included, so if it's used for `fileFilter`
      it would change the `subpath`/`components` value depending on which files are included.
- (+) If necessary, this restriction can be relaxed later, the opposite wouldn't be possible

### Strict path existence checking

Coercing paths that don't exist to file sets always gives an error.

- (-) Sometimes you want to remove a file that may not always exist using `difference ./. ./does-not-exist`,
  but this does not work because coercion of `./does-not-exist` fails,
  even though its existence would have no influence on the result.
  - (+) This is dangerous, because you wouldn't be protected against typos anymore.
    E.g. when trying to prevent `./secret` from being imported, a typo like `difference ./. ./sercet` would import it regardless.
  - (+) `difference ./. (maybeMissing ./does-not-exist)` can be used to do this more explicitly.
  - (+) `difference ./. (difference ./foo ./foo/bar)` should report an error when `./foo/bar` does not exist ("double negation"). Unfortunately, the current internal representation does not lend itself to a behavior where both `difference x ./does-not-exists` and double negation are handled and checked correctly.
    This could be fixed, but would require significant changes to the internal representation that are not worth the effort and the risk of introducing implicit behavior.
