# Perl {#sec-language-perl}

## Running Perl programs on the shell {#ssec-perl-running}

When executing a Perl script, it is possible you get an error such as `./myscript.pl: bad interpreter: /usr/bin/perl: no such file or directory`. This happens when the script expects Perl to be installed at `/usr/bin/perl`, which is not the case when using Perl from nixpkgs. You can fix the script by changing the first line to:

```perl
#!/usr/bin/env perl
```

to take the Perl installation from the `PATH` environment variable, or invoke Perl directly with:

```ShellSession
$ perl ./myscript.pl
```

When the script is using a Perl library that is not installed globally, you might get an error such as `Can't locate DB_File.pm in @INC (you may need to install the DB_File module)`. In that case, you can use `nix-shell` to start an ad-hoc shell with that library installed, for instance:

```ShellSession
$ nix-shell -p perl perlPackages.DBFile --run ./myscript.pl
```

If you are always using the script in places where `nix-shell` is available, you can embed the `nix-shell` invocation in the shebang like this:

```perl
#!/usr/bin/env nix-shell
#! nix-shell -i perl -p perl perlPackages.DBFile
```

## Packaging Perl programs {#ssec-perl-packaging}

Nixpkgs provides a function `buildPerlPackage`, a generic package builder function for any Perl package that has a standard `Makefile.PL`. It’s implemented in [pkgs/development/perl-modules/generic](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/perl-modules/generic).

Perl packages from CPAN are defined in [pkgs/top-level/perl-packages.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/perl-packages.nix) rather than `pkgs/all-packages.nix`. Most Perl packages are so straight-forward to build that they are defined here directly, rather than having a separate function for each package called from `perl-packages.nix`. However, more complicated packages should be put in a separate file, typically in `pkgs/development/perl-modules`. Here is an example of the former:

```nix
ClassC3 = buildPerlPackage rec {
  pname = "Class-C3";
  version = "0.21";
  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FL/FLORA/${pname}-${version}.tar.gz";
    hash = "sha256-/5GE5xHT0uYGOQxroqj6LMU7CtKn2s6vMVoSXxL4iK4=";
  };
};
```

Note the use of `mirror://cpan/`, and the `pname` and `version` in the URL definition to ensure that the `pname` attribute is consistent with the source that we’re actually downloading. Perl packages are made available in `all-packages.nix` through the variable `perlPackages`. For instance, if you have a package that needs `ClassC3`, you would typically write

```nix
foo = import ../path/to/foo.nix {
  inherit stdenv fetchurl ...;
  inherit (perlPackages) ClassC3;
};
```

in `all-packages.nix`. You can test building a Perl package as follows:

```ShellSession
$ nix-build -A perlPackages.ClassC3
```

To install it with `nix-env` instead: `nix-env -f. -iA perlPackages.ClassC3`.

So what does `buildPerlPackage` do? It does the following:

1. In the configure phase, it calls `perl Makefile.PL` to generate a Makefile. You can set the variable `makeMakerFlags` to pass flags to `Makefile.PL`
2. It adds the contents of the `PERL5LIB` environment variable to `#! .../bin/perl` line of Perl scripts as `-Idir` flags. This ensures that a script can find its dependencies. (This can cause this shebang line to become too long for Darwin to handle; see the note below.)
3. In the fixup phase, it writes the propagated build inputs (`propagatedBuildInputs`) to the file `$out/nix-support/propagated-user-env-packages`. `nix-env` recursively installs all packages listed in this file when you install a package that has it. This ensures that a Perl package can find its dependencies.

`buildPerlPackage` is built on top of `stdenv`, so everything can be customised in the usual way. For instance, the `BerkeleyDB` module has a `preConfigure` hook to generate a configuration file used by `Makefile.PL`:

```nix
{ buildPerlPackage, fetchurl, db }:

buildPerlPackage rec {
  pname = "BerkeleyDB";
  version = "0.36";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PM/PMQS/${pname}-${version}.tar.gz";
    hash = "sha256-4Y+HGgGQqcOfdiKcFIyMrWBEccVNVAMDBWZlFTMorh8=";
  };

  preConfigure = ''
    echo "LIB = ${db.out}/lib" > config.in
    echo "INCLUDE = ${db.dev}/include" >> config.in
  '';
}
```

Dependencies on other Perl packages can be specified in the `buildInputs` and `propagatedBuildInputs` attributes. If something is exclusively a build-time dependency, use `buildInputs`; if it’s (also) a runtime dependency, use `propagatedBuildInputs`. For instance, this builds a Perl module that has runtime dependencies on a bunch of other modules:

```nix
ClassC3Componentised = buildPerlPackage rec {
  pname = "Class-C3-Componentised";
  version = "1.0004";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AS/ASH/${pname}-${version}.tar.gz";
    hash = "sha256-ASO9rV/FzJYZ0BH572Fxm2ZrFLMZLFATJng1NuU4FHc=";
  };
  propagatedBuildInputs = [
    ClassC3 ClassInspector TestException MROCompat
  ];
};
```

On Darwin, if a script has too many `-Idir` flags in its first line (its “shebang line”), it will not run. This can be worked around by calling the `shortenPerlShebang` function from the `postInstall` phase:

```nix
{ lib, stdenv, buildPerlPackage, fetchurl, shortenPerlShebang }:

ImageExifTool = buildPerlPackage {
  pname = "Image-ExifTool";
  version = "12.50";

  src = fetchurl {
    url = "https://exiftool.org/${pname}-${version}.tar.gz";
    hash = "sha256-vOhB/FwQMC8PPvdnjDvxRpU6jAZcC6GMQfc0AH4uwKg=";
  };

  buildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
  postInstall = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/exiftool
  '';
};
```

This will remove the `-I` flags from the shebang line, rewrite them in the `use lib` form, and put them on the next line instead. This function can be given any number of Perl scripts as arguments; it will modify them in-place.

### Generation from CPAN {#ssec-generation-from-CPAN}

Nix expressions for Perl packages can be generated (almost) automatically from CPAN. This is done by the program `nix-generate-from-cpan`, which can be installed as follows:

```ShellSession
$ nix-env -f "<nixpkgs>" -iA nix-generate-from-cpan
```

Substitute `<nixpkgs>` by the path of a nixpkgs clone to use the latest version.

This program takes a Perl module name, looks it up on CPAN, fetches and unpacks the corresponding package, and prints a Nix expression on standard output. For example:

```ShellSession
$ nix-generate-from-cpan XML::Simple
  XMLSimple = buildPerlPackage rec {
    pname = "XML-Simple";
    version = "2.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.22.tar.gz";
      hash = "sha256-uUUO8i6pZErl1q2ghtxDAPoQW+BQogMOvU79KMGY60k=";
    };
    propagatedBuildInputs = [ XMLNamespaceSupport XMLSAX XMLSAXExpat ];
    meta = {
      description = "An API for simple XML files";
      license = with lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
```

The output can be pasted into `pkgs/top-level/perl-packages.nix` or wherever else you need it.

### Cross-compiling modules {#ssec-perl-cross-compilation}

Nixpkgs has experimental support for cross-compiling Perl modules. In many cases, it will just work out of the box, even for modules with native extensions. Sometimes, however, the Makefile.PL for a module may (indirectly) import a native module. In that case, you will need to make a stub for that module that will satisfy the Makefile.PL and install it into `lib/perl5/site_perl/cross_perl/${perl.version}`. See the `postInstall` for `DBI` for an example.
