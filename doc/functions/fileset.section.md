# File sets {#sec-fileset}

The [`lib.fileset`](#sec-functions-library-fileset) functions allow you to work with _file sets_.
File sets efficiently represent a set of local files.
They can easily be created and combined for complex behavior.
Their files can also be added to the Nix store and used as a derivation source.

The best way to experiment with file sets is to start a `nix repl` and load the file set functions:
```
$ nix repl -f '<nixpkgs/lib>'

nix-repl> :a fileset
Added 13 variables

nix-repl>
```

The most basic way to create file sets is by passing a [path](https://nixos.org/manual/nix/stable/language/values.html#type-path) to [`coerce`](#function-library-lib.fileset.coerce). The resulting file set depends on the path:
- If the path points to a file, the result is a file set only consisting of that single file.
- If the path points to a directory, all files in that directory will be in the resulting file set.

Let's try to create a file set containing just a local `Makefile` file:
```nix
nix-repl> coerce ./Makefile
{ __noEval = «error: error: File sets are not intended to be directly inspected or evaluated. Instead prefer:
       - If you want to print a file set, use the `lib.fileset.trace` or `lib.fileset.pretty` function.
       - If you want to check file sets for equality, use the `lib.fileset.equals` function.»; _base = /home/user/my/project; _tree = { ... }; _type = "fileset"; }
```

As you can see from the error message, we can't just print a file set directly. Instead let's use the [`trace`](#function-library-lib.fileset.trace) function as suggested:

```nix
nix-repl> trace {} (coerce ./Makefile) null
trace: /home/user/my/project
trace: - Makefile (regular)
null
```

From now on we'll use this simplified presentation of file set expressions and their resulting values:
```nix
coerce ./Makefile
```
```
/home/user/my/project
- Makefile (regular)
```

For convenience, all file set operations implicitly call [`coerce`](#function-library-lib.fileset.coerce) on arguments that are expected to be file sets, allowing us to simplify it to just:

```nix
# Implicit coerce when passing to `trace`
./Makefile
```
```
/home/user/my/project
- Makefile (regular)
```

Files need to exist, otherwise an error is thrown:
```nix
./non-existent
```
```
error: lib.fileset.trace: Expected second argument "/home/user/my/project/non-existent" to be a path that exists, but it doesn't.
```

File sets can be composed using the functions [`union`](#function-library-lib.fileset.union) (and the list-based equivalent [`unions`](#function-library-lib.fileset.unions)), [`intersect`](#function-library-lib.fileset.intersect) (and the list-based equivalent [`intersects`](#function-library-lib.fileset.intersects)) and [`difference`](#function-library-lib.fileset.difference), the most useful of which are [`unions`](#function-library-lib.fileset.unions) and [`difference`](#function-library-lib.fileset.difference):

```nix
# The file set containing the files from all list elements
unions [
  ./Makefile
  ./src
]
```
```
/home/user/my/project
- Makefile (regular)
- src (recursive directory)
```

```nix
# All files in ./. except ./Makefile
difference
  ./.
  ./Makefile
```
```
/home/user/my/project
- README.md (regular)
- src (recursive directory)
```

Another important function is [`fileFilter`](#function-library-lib.fileset.fileFilter), which filters out files based on a predicate function:
```nix
# Filter for C files contained in ./.
fileFilter
  (file: file.ext == "c")
  ./.
```
```
/home/user/my/project
- src
  - main.c (regular)
```

File sets can be added to the Nix store using the [`toSource`](#function-library-lib.fileset.toSource) function. This function returns a string-coercible value via `outPath`, meaning it can be used directly as directory in `src` or other uses.
```nix
nix-repl> toSource {
            root = ./.;
            fileset = union ./Makefile ./src;
          }
{
  # ...
  origSrc = /home/user/my/project;
  outPath = "/nix/store/4p6kpi1znyvih3qjzrzcwbh9sx1qdjpj-source";
}

$ cd /nix/store/4p6kpi1znyvih3qjzrzcwbh9sx1qdjpj-source

$ find .
.
./src
./src/main.c
./src/main.h
./Makefile
```

We can use this to declare the source of a derivation:
```nix
# default.nix
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "my-project";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.traceVal {} (lib.fileset.unions [
      ./Makefile
      ./src
    ]);
  };
  dontBuild = true;
  installPhase = ''
    find . > $out
  '';
}
```

```
$ nix-build
trace: /home/user/my/project
trace: - Makefile (regular)
trace: - src (recursive directory)
/nix/store/zz7b9zndh6575kagkdy9277zi9dmhz5f-my-project

$ cat result
.
./Makefile
./src
./src/main.c
./src/main.h
```

Sometimes we also want to make files outside the current `root` accessible. We can do this by setting the `root` to higher up:
```nix
lib.fileset.toSource {
  root = ../.;
  fileset = lib.fileset.unions [
    ./Makefile
    ./src
    ../utils.nix
  ];
};
```

However, we notice that the resulting file structure in the build directory changed:
```
$ nix-build && cat result
.
./utils.nix
./foo
./foo/src
./foo/src/main.c
./foo/src/main.h
./foo/Makefile
```

In order to prevent this we can use `srcWorkDir` to specify the local directory to start the build from:
```nix
# default.nix
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "my-project";
  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ./Makefile
      ./src
      ../utils.nix
    ];
  };
  # Make sure the build starts in ./.
  srcWorkDir = ./.;

  dontBuild = true;
  installPhase = ''
    find . > $out
    echo "Utils: $(cat ../utils.nix)" >> $out
  '';
}
```

```
$ nix-build && cat result
.
./Makefile
./src
./src/main.h
./src/main.c
Utils: # These are utils!
```

However for more convenience there's integration of file set functionality into `stdenv.mkDerivation` using the `srcFileset` attribute, which then doesn't require setting `root` anymore:

```
# default.nix
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "my-project";
  srcFileset = lib.fileset.unions [
    ./Makefile
    ./src
    ../utils.nix
  ];
  srcWorkDir = ./.;

  dontBuild = true;
  installPhase = ''
    find . > $out
    echo "Utils: $(cat ../utils.nix)" >> $out
  '';
}
```

This covers the basics of almost all functions available, see the full reference [here](#sec-functions-library-fileset).
