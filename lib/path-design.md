# Path library design

This document documents why the `lib.path` library is designed the way it is.

The goal of this library is to support the built-in path value type with extra functionality.
Since the path value type implicitly imports paths from the eval-time system into the store,
this library explicitly doesn't support build-time or runtime paths, including paths of derivations.

Overall, this library works with two basic forms of paths:
- Absolute paths are represented with the path value type. Nix automatically normalises these paths.
- Relative paths are represented with the string value type. This library normalises these paths as safely as possible.

Notably absolute paths in a string value type are not supported, the use of the string value type for relative paths is only because the path value type doesn't support relative paths.

This library is designed to be as safe and intuitive as possible, throwing errors when potentially unsafe operations are tried, and giving an expected result otherwise.

This library is designed to work well as a dependency for the `lib.filesystem` and `lib.sources` library components. Contrary to these library components, `lib.path` is designed to not read any paths from the filesystem.

## Use cases
- Source filters and [Source combinators](https://github.com/NixOS/nixpkgs/pull/112083)
- Filesystem paths in NixOS


## API

### `join`

Joins paths together with `/`. All but the first component must be relative. Returns the same data type as the first element.

Examples:
- `join [/foo "bar"] == /foo/bar`
- `join ["foo" "bar/baz"] == "foo/bar/baz"`
- `join [/foo ".." "bar"] == <error>`
- `join [/foo "/bar"] == <error>`
- `join [ "foo" (removePrefix /. /bar) ] == "foo/bar"`

Laws:
- The result is normalised:
  `join ps == normalise (join ps)`
- Joining a single path is that path itself, but normalised:
  join [ p ] == normalise p

Use cases:
- TODO

### `normalise`

Normalizes paths. For absolute path values, nothing is done as Nix already normalises those. For relative path the following is done:
- Limiting repeating `/` to a single one (does not change a [POSIX Pathname](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_271))
- Removing extraneous `.` components (does not change the result of [POSIX Pathname Resolution](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap04.html#tag_04_13))
- Erroring for empty strings (not allowed as a [POSIX Filename](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_170))
- Removing trailing `/` and `/.` (See [justification](#trailing-slashes))
- Erroring for ".." components (See [justification](#parents))
- Removing leading `./` (See [justification](#leading-dots))

Examples:
- `normalise "foo//bar" == "foo/bar"`
- `normalise "foo/./bar" == "foo/bar"`
- `normalise "" == <error>`
- `normalise "foo/bar/" == "foo/bar"`
- `normalise "foo/bar/." == "foo/bar"`
- `normalise "foo/../bar" == <error>`
- `normalise "./foo/bar" == "foo/bar"`

Laws:
- Idempotency:
  `normalise (normalise p) == normalise p`
- Behaves like `realpath`:
  `isAbsolute p => normalise p == realpath --no-symlinks --canonicalize-missing p`
  `isRelative p => normalise p == realpath --no-symlinks --canonicalize-missing --relative-to=. p`

Use cases:
- As an attribute name for a path -> value lookup attribute set
  - E.g. `environment.etc.<path>`
- Path equality comparison

### `removePrefix`

Removes a base directory prefix from a path, returning a relative path.

Examples:
- `removePrefix /foo /foo/bar == "bar"`
- `removePrefix /baz /foo/bar == <error>`
- `removePrefix "foo" "foo/bar" == "bar"`
- `removePrefix "foo" /foo/bar == <error>`
- `removePrefix /. /foo/bar == "foo/bar"`

Use cases:
- For source combinators, a way to set a source to point to a subpath using `setSubpath ./foo/bar ./.`. This needs to calculate the relative path `foo/bar` from the absolute path `./foo/bar` resolved by Nix

Laws:

### `hasPrefix`

Returns whether a path has a specific base directory prefix. Returns true iff `removePrefix` doesn't error for the same arguments.

Examples:
- `hasPrefix /foo /foo/bar == true`
- `hasPrefix /baz /foo/bar == false`
- `hasPrefix "foo" "foo/bar" == true`
- `hasPrefix "foo" /foo/bar == false`
- `hasPrefix /. /foo/bar == true`

Use cases:
- Checking whether `removePrefix` would error before calling it

Laws:

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

- :heavy_minus_sign: In shells, just running `foo` as a command wouldn't execute the file `foo`, whereas `./foo` would execute the file. In contrast, `foo/bar` does execute that file without the need for `./`. This can lead to confusion about when a `./` needs to be prefixed. If a `./` is always included, this becomes a non-issue. This effectively then means that paths don't overlap with command names.
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
- :heavy_plus_sign: Leads to `split "/foo/bar" == [ "/" "./foo" "./bar" ]`, which
  - Is less performant
  - Less pretty
    - :heavy_minus_sign: This doesn't really matter though
  - Makes each component have a `/` on its own, seeming like the components weren't fully split. Joining the string components together with `/` gives `/./foo/./bar` which is unnecessarily complex
    - :heavy_minus_sign: This doesn't really matter though
- :heavy_plus_sign: Leads to wanting `split "foo" == [ "." "./foo" ]`
  - Makes `./foo` splittable into `[ "." "./foo" ]` again
  - :heavy_minus_sign: Why does that matter?
    - :heavy_plus_sign: Makes it less performant
    - :heavy_plus_sign: Makes it less performant

### Two leading slashes
[two-slashes]: #two-leading-slashes

Context: POSIX [specifies](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_271) that exactly two leading slashes (e.g. `//foo/bar`) should be handled specially and that the first component can be resolved in an [implementation-defined way](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap04.html#tag_04_13).

Decision: We don't handle this specially and treat `//foo/bar` the same as `/foo/bar`

- :heavy_plus_sign: These paths generally [aren't used](https://unix.stackexchange.com/questions/256497/on-what-systems-is-foo-bar-different-from-foo-bar)
- :heavy_plus_sign: Handling these, even just erroring or ignoring them, would complicate the implementation and decrease performance

### Representation of the current directory
[curdir]: #representation-of-the-current-directory

Context: The current directory can be represented with `.` or `./` or `./.`

Decision: It should be `./.`

- :heavy_plus_sign: `.` would be the only path without a `/` and therefore not a valid Nix path in expressions
  - :heavy_minus_sign: We don't require people to type this in expressions
- :heavy_plus_sign: `.` can be interpreted as a shell command (it's a builtin command for zsh)
- :heavy_plus_sign: `./` inconsistent with [the decision to not have trailing slashes](#trailing-slashes)
- :heavy_minus_sign: `./.` is rather long
  - :heavy_plus_sign: We don't require users to type this though, it's only used as a library output.
    As inputs all three variants are supported

### `split` being part of the public API
[public-split]: #split-being-part-of-the-public-api

Context: The main use case for `split` seems to be internal to the library and might not need to be exposed as a public API.
The inverse `join` does have lots of use cases though (it appends path components), so it should definitely be part of the public API

Decision: `split` should be part of the public API

- :heavy_minus_sign: We don't want to encourage custom path handling, which `split` enables
  - :heavy_plus_sign: If there's a need for it, people will do custom handling either way. `split` is a primitive that can make this safer
- :heavy_plus_sign: We might not be able to cover all use cases with our path library

### Representation
[representation]: #representation

Context: Paths can be represented directly as a string, or as an attribute set like `{ components = [ "foo" "bar" ]; anchor = "/"; }`

Decision: Paths are represented as strings

- :heavy_plus_sign: It's simpler
- :heavy_plus_sign: It's faster
  - :heavy_minus_sign: Unless you need to do certain path operations in sequence, e.g. `join [ (join [ "/foo" "bar" ]) "baz" ]` needs the inner `join` to return a string composed of its arguments, only for that string to be decomposed again in the outer `join`
    - :heavy_plus_sign: We can mostly avoid such costs by exporting sufficiently powerful functions, so that users don't need to make multiple roundtrips to the library representation
- :heavy_plus_sign: `+` is convenient and doesn't work on attribute sets
  - :heavy_minus_sign: It works if we add `__toString` attributes
    - :heavy_plus_sign: But then all other attributes get wiped
    - :heavy_plus_sign: And we'd then be able to `+` paths again

### Parents
[parents]: #parents

Context: Paths can have `..` components, which refer to the parent directory

Decision: `..` path components are not supported, nor as inputs nor as outputs.

- :heavy_plus_sign: It requires resolving symlinks to have proper behavior, since e.g. `foo/..` would not be the same as `.` if `foo` is a symlink.
  - :heavy_plus_sign: We can't resolve symlinks without filesystem access
  - :heavy_plus_sign: Nix also doesn't support reading symlinks at eval-time
  - :heavy_minus_sign: What is "proper behavior"? Why can't we just not handle these cases?
    - :heavy_plus_sign: E.g. `equals "/foo" "/foo/bar/.."` should those paths be equal?
      - :heavy_minus_sign: That can just return `false`, the paths are different, we don't need to check whether the paths point to the same thing
    - :heavy_plus_sign: E.g. `relativeTo "/foo" "/bar" == "../foo"`. If this is used like `/bar/../foo` in the end and `bar` is a symlink to somewhere else, this won't be accurate
      - :heavy_minus_sign: We could not support such ambiguous operations, or mark them as such, e.g. the normal `relativeTo` will error on such a case, but there could be `extendedRelativeTo` supporting that
- :heavy_minus_sign: `..` are a part of paths, a path library should therefore support it
  - :heavy_plus_sign: If we can prove that all such use cases are better done e.g. with runtime tools, the library not supporting it can nudge people towards that
    - :heavy_minus_sign: Can we prove that though?
- :heavy_minus_sign: We could allow ".." just in the beginning
  - :heavy_plus_sign: Then we'd have to throw an error for doing `join [ "/some/path" "../foo" ]`, making it non-composable
  - :heavy_plus_sign: The same is for returning paths with `..`: `relativeTo "/foo" "/bar" => "../foo"` would produce a non-composable path
- :heavy_plus_sign: We argue that `..` is not needed at the Nix evaluation level, since we'd always start evaluation from the project root and don't go up from there
  - :heavy_plus_sign: And `..` is supported in Nix paths, turning them into absolute paths
    - :heavy_minus_sign: This is ambiguous with symlinks though
- :heavy_plus_sign: If you need `..` for building or runtime, you can use build/run-time tooling to create those (e.g. `realpath` with `--relative-to`), or use absolute paths instead.
  This also gives you the ability to correctly handle symlinks

### Trailing slashes
[trailing-slashes]: #trailing-slashes

Context: Paths can contain trailing slashes, like `foo/`, indicating that the path points to a directory and not a file

Decision: All functions remove trailing slashes in their results

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
- :heavy_plus_sign: Nix's builtin function `dirOf` gives an unexpected result for paths with trailing slashes: `dirOf "/foo/bar/" == "/foo/bar"`.
  Inconsistently, `baseNameOf` works correctly though: `baseNameOf "/foo/bar/" == "bar"`.
  - :heavy_minus_sign: We are writing a path library to improve handling of paths though, so we shouldn't use these functions and discourage their use
- :heavy_minus_sign: Unexpected result when normalising intermediate paths, like `normalise ("/foo" + "/") + "bar" == "/foobar"`
  - :heavy_plus_sign: Does this have a real use case?
  - :heavy_plus_sign: Don't use `+` to append paths, this library has a `join` function for that
    - :heavy_minus_sign: Users might use `+` instinctively though
- :heavy_plus_sign: The `realpath` command also removes trailing slashes
- :heavy_plus_sign: Even with a trailing slash, the path is the same, it's only an indication that it's a directory
- :heavy_plus_sign: Normalisation should return the same string when we know it's the same path, so removing the slash.
  This way we can use the result as an attribute key.

TODO:
- Add more language comparisons

## Other implementations and references

- [Rust](https://doc.rust-lang.org/std/path/struct.Path.html)
- [Python](https://docs.python.org/3/library/pathlib.html)
- [Haskell](https://hackage.haskell.org/package/filepath-1.4.100.0/docs/System-FilePath.html)
- [Nodejs](https://nodejs.org/api/path.html)
- [POSIX.1-2017](https://pubs.opengroup.org/onlinepubs/9699919799/nframe.html)
