# pkgs.nix-gitignore {#sec-pkgs-nix-gitignore}

`pkgs.nix-gitignore` is a function that acts similarly to `builtins.filterSource` but also allows filtering with the help of the gitignore format.

## Usage {#sec-pkgs-nix-gitignore-usage}

`pkgs.nix-gitignore` exports a number of functions, but you'll most likely need either `gitignoreSource` or `gitignoreSourcePure`. As their first argument, they both accept either 1. a file with gitignore lines or 2. a string with gitignore lines, or 3. a list of either of the two. They will be concatenated into a single big string.

```nix
{ pkgs ? import <nixpkgs> {} }:

 nix-gitignore.gitignoreSource [] ./source
     # Simplest version

 nix-gitignore.gitignoreSource "supplemental-ignores\n" ./source
     # This one reads the ./source/.gitignore and concats the auxiliary ignores

 nix-gitignore.gitignoreSourcePure "ignore-this\nignore-that\n" ./source
     # Use this string as gitignore, don't read ./source/.gitignore.

 nix-gitignore.gitignoreSourcePure ["ignore-this\nignore-that\n", ~/.gitignore] ./source
     # It also accepts a list (of strings and paths) that will be concatenated
     # once the paths are turned to strings via readFile.
```

These functions are derived from the `Filter` functions by setting the first filter argument to `(_: _: true)`:

```nix
gitignoreSourcePure = gitignoreFilterSourcePure (_: _: true);
gitignoreSource = gitignoreFilterSource (_: _: true);
```

Those filter functions accept the same arguments the `builtins.filterSource` function would pass to its filters, thus `fn: gitignoreFilterSourcePure fn ""` should be extensionally equivalent to `filterSource`. The file is blacklisted if it's blacklisted by either your filter or the gitignoreFilter.

If you want to make your own filter from scratch, you may use

```nix
gitignoreFilter = ign: root: filterPattern (gitignoreToPatterns ign) root;
```

## gitignore files in subdirectories {#sec-pkgs-nix-gitignore-usage-recursive}

If you wish to use a filter that would search for .gitignore files in subdirectories, just like git does by default, use this function:

```nix
gitignoreFilterRecursiveSource = filter: patterns: root:
# OR
gitignoreRecursiveSource = gitignoreFilterSourcePure (_: _: true);
```
