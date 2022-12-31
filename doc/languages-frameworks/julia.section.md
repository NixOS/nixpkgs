# Julia {#sec-julia}

## Introduction {#ssec-julia-introduction}

The [Julia programming language](https://julialang.org/) was developed
with scientific applications in mind. It is distributed with a package
manager and the vast majority of packages are available through the
main package server
[pkg.julialang.org](https://pkg.julialang.org). While the native
package manager can be used to easily and declaratively install
packages, several ones come with binary blobs (called artifacts in
Julia parlance) that do not work in NixOS. To remedy this shortcoming,
Julia packages can be installed as described below. This way the
binary blobs are patched to work as expected and all software can be
declared in a single file.

### Installing Julia Packages {#sssec-installing-julia-packages}

Most Julia compilers available in Nixpkgs have a passthru attribute
called `withPackages`. This function permits creating Julia
environments with sets of packages ready for use. Compared with the
similarly named function available in other Nixpkgs language
frameworks, the one of Julia takes two arguments. The first one is a
function specifying a list of Julia packages available in Nixpkgs. The
second one is also a function, and it's used to specify a list of
extra package definitions not available in Nixpkgs. These definitions
can be generated with the help of `julia2nix`. As an example, to
install `julia-bin` with the Nixpkgs Julia package `Plots`, all its
dependencies and the upstream package `CSTParser` with its dependency
`Tokenize`, one can use the following command

```ShellSession
$ nix-shell -p 'julia-bin.withPackages
   (p: with p; [ Plots ])
   (p: with p; [
     { pname = "Tokenize";
       version = "0.5.25";
       src = fetchurl {
         url = "https://pkg.julialang.org/package/0796e94c-ce3b-5d07-9a54-7f471281c624/90538bf898832b6ebd900fa40f223e695970e3a5";
         name = "julia-bin-1.8.3-Tokenize-0.5.25.tar.gz";
         sha256 = "00437718f09d81958e86c2131f3f8b63e0975494e505f6c7b62f872a5a102f51";
       };
     }

     { pname = "CSTParser";
       version = "3.3.6";
       src = fetchurl {
         url = "https://pkg.julialang.org/package/00ebfdb7-1f24-5e51-bd34-a7502290713f/3ddd48d200eb8ddf9cb3e0189fc059fd49b97c1f";
         name = "julia-bin-1.8.3-CSTParser-3.3.6.tar.gz";
         sha256 = "647fc5588cb87362d216401a0a4124d41b80a85618a94098a737ad38ae5786c4";
       };
       requiredJuliaPackages = [ Tokenize ];
     }
   ])
'
```

This is not very practical as a `nix-shell` command, but the same
expression can be used in a `shell.nix` file, or other places
expecting a Nix expression as described elsewhere in this
manual. After executing this command and starting Julia, the packages
can be directly imported with `using` or `import` without first having
to use `import Pkg; Pkg.add(...)`.

The list of Julia packages in Nixpkgs is accessible through the
compiler passthru attribute set `juliaPackages`, for example
`julia-bin.juliaPackages`.

Note that the above upstream package definitions are addressed with an
`url` specifying a unique package identifier (uuid) and the hash of
the package content. For this reason we don't lose reproducibility by
using upstream packages.
