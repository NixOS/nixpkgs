# Path library design

This document documents why the `lib.path` library is designed the way it is.

The purpose of this library is to process paths. It does not read files from the filesystem.
It exists to support the native Nix path value type with extra functionality.

Since the path value type implicitly imports paths from the "eval-time system" into the store,
this library explicitly doesn't support build-time or run-time paths, including paths to derivations.

Overall, this library works with two basic forms of paths:
- Absolute paths are represented with the Nix path value type. Nix automatically normalises these paths.
- Relative paths are represented with the string value type. This library normalises these paths as safely as possible.

Notably absolute paths in a string value type are not supported, the use of the string value type for relative paths is only because the path value type doesn't support relative paths.

This library is designed to be as safe and intuitive as possible, throwing errors when operations are attempted that would produce surprising results, and giving the expected result otherwise.

This library is designed to work well as a dependency for the `lib.filesystem` and `lib.sources` library components. Contrary to these library components, `lib.path` is designed to not read any paths from the filesystem.

## API

### `append`

```haskell
append :: Path -> String -> Path
```

Append a relative path to an absolute path.

Like `<path> + ("/" + <string>)` but safer.

Examples:
```nix
append /foo "bar" == /foo/bar

# can append to root directory
append /. "foo" == /foo

# normalise the path
append /foo "bar//./baz" == /foo/bar/baz

# remove trailing slashes
append /foo "bar/" == /foo/bar

# do not handle parent directory, as it may break underlying symlinks
append /foo "foo/../bar" == <error>

# prevent appending empty strings by accident
append /foo "" == <error>

# prevent appending absolute paths by accident
append /foo "/bar" == <error>
```

### `relative.join`

```haskell
relative.join :: [ String ] -> String 
```

Join relative paths using `/`.

Like `concatStringsSep "/"` but safer.

Examples:
```nix
relative.join ["foo" "bar"] == "foo/bar"
relative.join ["foo" "bar/baz" ] == "foo/bar/baz"
relative.join [ "." ] == "."
relative.join [ "." "foo" ] == "foo"

# normalise the path
relative.join ["./foo" "bar//./baz/" "./qux" ] == "foo/bar/baz/qux"

# empty list is the current directory
relative.join [] == "."

# do not handle parent directory, as it may break underlying symlinks
relative.join ["foo" ".."] == <error>

# do not handle absolute paths elements
relative.join ["/foo" "bar"] == <error>
relative.join ["foo" "/bar"] == <error>
relative.join ["foo" "/" ] == <error>
```

Laws:
- Associativity:
  `relative.join [ x (join [ y z ]) ] == relative.join [ (join [ x y ]) z ]`
- Identity:
  `relative.join [] == "."`
  `relative.join [p "."] == normalise p`
  `relative.join ["." p] == normalise p`
- The result is normalised:
  `relative.join ps == normalise (relative.join ps)`
- Joining a single path is that path itself, but normalised:
  `relative.join [ p ] == normalise p`

### `relative.normalise`

```haskell
relative.normalise :: String -> String
```

Normalise relative paths.

- Limit repeating `/` to a single one (does not change a [POSIX Pathname](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_271))
- Remove redundant `.` components (does not change the result of [POSIX Pathname Resolution](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap04.html#tag_04_13))
- Error on empty strings (not allowed as a [POSIX Filename](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_170))
- Remove trailing `/` and `/.` (See [justification](#trailing-slashes))
- Error on `..` path components (See [justification](#parents))
- Remove leading `./` (See [justification](#leading-dots))

Examples:
```
# limit repeating `/` to a single one
relative.normalise "foo//bar" == "foo/bar"

# remove redundant `.` components
relative.normalise "foo/./bar" == "foo/bar"

# remove leading `./`
# TODO: bikeshedding. there is a use to this.
relative.normalise "./foo/bar" == "foo/bar"

# remove trailing `/`
relative.normalise "foo/bar/" == "foo/bar"

# remove trailing `/.`
relative.normalise "foo/bar/." == "foo/bar"

# error on `..` path components
relative.normalise "foo/../bar" == <error>

# error on empty string
relative.normalise "" == <error>

# error on absolute path
relative.normalise "/foo" == <error>
```

Laws:
- Idempotency:

  `relative.normalise (relative.normalise p) == relative.normalise p`

- Doesn't change the file system object pointed to:

  `$(stat ${p}) == $(stat ${relative.normalise p})`

  TODO: Is this the same as the law below?

- Uniqueness: If the normalisation of two paths is different then they point to different paths:

  `normalise p != normalise q => $(stat ${p}) != $(stat ${q})`

  Note: This law only holds if trailing slashes are not persisted, see the [trailing slashes decision](#trailing-slashes)

### `difference`

```haskell
difference :: AttrsOf Path -> { commonPrefix :: Path; suffix :: AttrsOf String; }
```

Take the difference between multiple paths, returning the common prefix between them and the respective suffices.

Examples:
```nix
difference { path = /foo/bar } = { commonPrefix = /foo/bar; suffix = { path = "."; }; }
difference { left = /foo/bar; right = /foo/baz; } = { commonPrefix = /foo; suffix = { left = "bar"; right = "baz"; }; }
difference { left = /foo; right = /foo/bar; } = { commonPrefix = /foo; suffix = { left = "."; right = "bar"; }; }
difference { left = /.; right = /foo; } = { commonPrefix = /.; suffix = { left = "."; right = "bar"; }; }
difference { left = /foo; right = /foo; } = { commonPrefix = /foo; suffix = { left = "."; right = "."; }; }

# Requires at least one path
difference {} = <error>
```

### `relativeTo`

```haskell
relativeTo :: Path -> Path -> String
```

Returns the relative path to go from a base absolute path to a specific descendant.

TODO Not sure about the name, ideas are:
- `relativeTo`: We might want to use `relativeTo` for a function that can return `..`, but that's not a problem because this function can just throw an error until (if ever) that's supported
- `removePrefix`, `stripPrefix`: Might accidentally use the string variants which have non-desired behavior on paths, we could fix those though, and we are qualified under `lib.path.*` anyways
- `subpathBetween`, `subpathFrom`, `subpathFromTo`: Introduces the "subpath" concept when it's not mentioned anywhere else
- `descendantSubpath`: Would be nice to align this somehow with comparison functions
- Don't have this function, can use `difference` instead
- Prefix this function name with `_` to signify it's not final and might change in the future?

Examples:
```
relativeTo /foo /foo/bar == "bar"
relativeTo /. /foo/bar == "foo/bar"
relativeTo /baz /foo/bar == <error>
```

Laws:
- `relativeTo p p == "."`
- `relativeTo p (append p q) = relative.normalise q`

### Partial ordering query functions

Paths with their ancestor-descendant relationship are a [partial ordered set](https://en.wikipedia.org/wiki/Partially_ordered_set) (proof left as an exercise to the reader). We should have some basic functions for querying that relationship. This is at least necessary to check whether `relativeTo` errors or not before calling it.

```
isDescendantOf /foo /foo/bar == true
isDescendantOf /foo /foo == ??
isAncestorOf /foo/bar /foo == true
isAncestorOf /foo /foo == ??

isProperDescendantOf /foo /foo/bar == true
isProperDescendantOf /foo /foo == ??
isProperAncestorOf /foo/bar /foo == true
isProperAncestorOf /foo /foo == ??

isDescendantOrEqual /foo /foo/bar == true
isDescendantOrEqual /foo /foo == true
isAncestorOrEqual /foo/bar /foo == true
isAncestorOrEqual /foo /foo == true

containedIn /foo /foo/bar == true
containedIn /foo /foo == true
contains /foo/bar /foo == true
contains /foo /foo == true

partOf /foo /foo/bar == true

isEquals /foo /foo == true
equals /foo /foo == true

```

### Out of scope (for now at least)

- isAbsolute and related functions
- baseNameOf
- dirOf
- isRelativeTo
- commonAncestor
- equals
- extension getter/setter
- List of all ancestors (including self), like <https://doc.rust-lang.org/std/path/struct.PathBuf.html#method.ancestors>

## General design decisions

Each subsection here contains a decision along with arguments and counter-arguments for (+) and against (-) that decision.

### Leading dots for relative paths
[leading-dots]: #leading-dots-for-relative-paths

Context: Relative paths can have a leading `./` to indicate it being a relative path, this is generally not necessary for tools though

Decision: Returned relative paths should never have a leading `./`

TODO: Inconsistent with the decision [to use `./.` for the current directory][curdir].

- :heavy_minus_sign: In shells, just running `foo` as a command wouldn't execute the file `foo`, whereas `./foo` would execute the file. In contrast, `foo/bar` does execute that file without the need for `./`. This can lead to confusion about when a `./` needs to be prefixed. If a `./` is always included, this becomes a non-issue. This effectively then means that paths don't overlap with command names.
- :heavy_minus_sign: Nix path expressions need at least a single `/` to trigger, so adding a `./` would make that work
  - :heavy_minus_sign: Though there's no good reason why anybody would want to put the output of path expressions directly back into Nix, and if it doesn't work they'd immediately get a parse error anyways
- :heavy_minus_sign: Using paths in command line arguments could give problems if not escaped properly, e.g. if a path was `--version`. This is not a problem with `./--version`. This effectively then means that paths don't overlap with GNU-style command line options
- :heavy_plus_sign: The POSIX standard doesn't require `./`
- :heavy_plus_sign: It's more pretty without the `./`, good for error messages and co.
  - :heavy_minus_sign: But similarly, it could be confusing whether something was even a path
    e.g. `foo` could be anything, but `./foo` is more clearly a path
- :heavy_minus_sign: Makes it more uniform with absolute paths (those always start with `/`)
  - :heavy_plus_sign: Not relevant though, this perhaps only simplifies the implementation a tiny bit
- :heavy_minus_sign: Makes even single-component relative paths (like `./foo`) valid as a path expression in Nix (`foo` wouldn't be)
  - :heavy_plus_sign: Not relevant though, we won't use these paths in Nix expressions
- :heavy_minus_sign: `find` also outputs results with `./`
  - :heavy_plus_sign: But only if you give it an argument of `.`. If you give it the argument `some-directory`, it won't prefix that
- :heavy_plus_sign: `realpath --relative-to` doesn't output `./`'s

### Representation of the current directory
[curdir]: #representation-of-the-current-directory

Context: The current directory can be represented with `.` or `./` or `./.`

Decision: It should be `./.`

- :heavy_plus_sign: `./` would be inconsistent with [the decision to not have trailing slashes](#trailing-slashes)
- :heavy_minus_sign: `.` is how `realpath` normalises paths
- :heavy_plus_sign: `.` can be interpreted as a shell command (it's a builtin for sourcing files in bash and zsh)
- :heavy_plus_sign: `.` would be the only path without a `/` and therefore not a valid Nix path in expressions
- :heavy_minus_sign: `./.` is rather long
  - :heavy_minus_sign: We don't require users to type this though, it's mainly just used as a library output.
    As inputs all three variants are supported for relative paths (and we can't do anything about absolute paths)
- :heavy_minus_sign: `builtins.dirOf "foo" == "."`, so `.` would be consistent with that

### Relative path representation
[relrepr]: #relative-path-representation

Context: Relative paths can be represented as a string, a list with all the components like `[ "foo" "bar" ]` for `foo/bar`, or with an attribute set like `{ type = "relative-path"; components = [ "foo" "bar" ]; }`

Decision: Paths are represented as strings

- :heavy_plus_sign: It's simpler for the end user, as one doesn't need to make sure the path is in a string representation before it can be used
  - :heavy_plus_sign: Also `concatStringsSep "/"` might be used to turn a relative list path value into a string, which then breaks for `[]`
- :heavy_plus_sign: It doesn't encourage people to do their own path processing and instead use the library
  E.g. With lists it would be very easy to just use `lib.lists.init` to get the parent directory, but then it breaks for `.`, represented as `[ ]`
- :heavy_plus_sign: `+` is convenient and doesn't work on lists and attribute sets
  - :heavy_minus_sign: Shouldn't use `+` anyways, we export safer functions for path manipulation

### Parents
[parents]: #parents

Context: Relative paths can have `..` components, which refer to the parent directory

Decision: `..` path components in relative paths are not supported, nor as inputs nor as outputs.

- :heavy_plus_sign: It requires resolving symlinks to have proper behavior, since e.g. `foo/..` would not be the same as `.` if `foo` is a symlink.
  - :heavy_plus_sign: We can't resolve symlinks without filesystem access
  - :heavy_plus_sign: Nix also doesn't support reading symlinks at eval-time
  - :heavy_minus_sign: What is "proper behavior"? Why can't we just not handle these cases?
    - :heavy_plus_sign: E.g. `equals "foo" "foo/bar/.."` should those paths be equal?
      - :heavy_minus_sign: That can just return `false`, the paths are different, we don't need to check whether the paths point to the same thing
    - :heavy_plus_sign: E.g. `relativeTo /foo /bar == "../foo"`. If this is used like `/bar/../foo` in the end and `bar` is a symlink to somewhere else, this won't be accurate
      - :heavy_minus_sign: We could not support such ambiguous operations, or mark them as such, e.g. the normal `relativeTo` will error on such a case, but there could be `extendedRelativeTo` supporting that
- :heavy_minus_sign: `..` are a part of paths, a path library should therefore support it
  - :heavy_plus_sign: If we can prove that all such use cases are better done e.g. with runtime tools, the library not supporting it can nudge people towards that
    - :heavy_minus_sign: Can we prove that though?
- :heavy_minus_sign: We could allow ".." just in the beginning
  - :heavy_plus_sign: Then we'd have to throw an error for doing `append /some/path "../foo"`, making it non-composable
  - :heavy_plus_sign: The same is for returning paths with `..`: `relativeTo /foo /bar => "../foo"` would produce a non-composable path
- :heavy_plus_sign: We argue that `..` is not needed at the Nix evaluation level, since we'd always start evaluation from the project root and don't go up from there
  - :heavy_plus_sign: And `..` is supported in Nix paths, turning them into absolute paths
    - :heavy_minus_sign: This is ambiguous with symlinks though
- :heavy_plus_sign: If you need `..` for building or runtime, you can use build/run-time tooling to create those (e.g. `realpath` with `--relative-to`), or use absolute paths instead.
  This also gives you the ability to correctly handle symlinks

### Trailing slashes
[trailing-slashes]: #trailing-slashes

Context: Relative paths can contain trailing slashes, like `foo/`, indicating that the path points to a directory and not a file

Decision: All functions remove trailing slashes in their results

- :heavy_plus_sign: It enables the law that if `normalise p == normalise q` then `$(stat p) == $(stat q)`.
- Comparison to other frameworks to figure out the least surprising behavior:
  - :heavy_plus_sign: Nix itself doesn't preserve trailing newlines when parsing and appending its paths
  - :heavy_minus_sign: [Rust's std::path](https://doc.rust-lang.org/std/path/index.html) does preserve them during [construction](https://doc.rust-lang.org/std/path/struct.Path.html#method.new)
    - :heavy_plus_sign: Doesn't preserve them when returning individual [components](https://doc.rust-lang.org/std/path/struct.Path.html#method.components)
    - :heavy_plus_sign: Doesn't preserve them when [canonicalizing](https://doc.rust-lang.org/std/path/struct.Path.html#method.canonicalize)
  - :heavy_plus_sign: [Python 3's pathlib](https://docs.python.org/3/library/pathlib.html#module-pathlib) doesn't preserve them during [construction](https://docs.python.org/3/library/pathlib.html#pathlib.PurePath)
    - Notably it represents the individual components as a list internally
  - :heavy_minus_sign: [Haskell's filepath](https://hackage.haskell.org/package/filepath-1.4.100.0) has [explicit support](https://hackage.haskell.org/package/filepath-1.4.100.0/docs/System-FilePath.html#g:6) for handling trailing slashes
    - :heavy_minus_sign: Does preserve them for [normalisation](https://hackage.haskell.org/package/filepath-1.4.100.0/docs/System-FilePath.html#v:normalise)
  - :heavy_minus_sign: [NodeJS's Path library](https://nodejs.org/api/path.html) preserves trailing slashes for [normalisation](https://nodejs.org/api/path.html#pathnormalizepath)
    - :heavy_plus_sign: For [parsing a path](https://nodejs.org/api/path.html#pathparsepath) into its significant elements, trailing slashes are not preserved
- :heavy_plus_sign: Nix's builtin function `dirOf` gives an unexpected result for paths with trailing slashes: `dirOf "foo/bar/" == "foo/bar"`.
  Inconsistently, `baseNameOf` works correctly though: `baseNameOf "foo/bar/" == "bar"`.
  - :heavy_minus_sign: We are writing a path library to improve handling of paths though, so we shouldn't use these functions and discourage their use
- :heavy_minus_sign: Unexpected result when normalising intermediate paths, like `normalise ("foo" + "/") + "bar" == "foobar"`
  - :heavy_plus_sign: Does this have a real use case?
  - :heavy_plus_sign: Don't use `+` to append paths, this library has a `join` function for that
    - :heavy_minus_sign: Users might use `+` out of habit though
- :heavy_plus_sign: The `realpath` command also removes trailing slashes
- :heavy_plus_sign: Even with a trailing slash, the path is the same, it's only an indication that it's a directory
- :heavy_plus_sign: Normalisation should return the same string when we know it's the same path, so removing the slash.
  This way we can use the result as an attribute key.

## Other implementations and references

- [Rust](https://doc.rust-lang.org/std/path/struct.Path.html)
- [Python](https://docs.python.org/3/library/pathlib.html)
- [Haskell](https://hackage.haskell.org/package/filepath-1.4.100.0/docs/System-FilePath.html)
- [Nodejs](https://nodejs.org/api/path.html)
- [POSIX.1-2017](https://pubs.opengroup.org/onlinepubs/9699919799/nframe.html)
