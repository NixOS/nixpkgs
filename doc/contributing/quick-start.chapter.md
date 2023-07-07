# Quick Start to Adding a Package {#chap-quick-start}

To add a package to Nixpkgs:

1. Checkout the Nixpkgs source tree:

   ```ShellSession
   $ git clone https://github.com/NixOS/nixpkgs
   $ cd nixpkgs
   ```

2. Find a good place in the Nixpkgs tree to add the Nix expression for your package. For instance, a library package typically goes into `pkgs/development/libraries/pkgname`, while a web browser goes into `pkgs/applications/networking/browsers/pkgname`. See [](#sec-organisation) for some hints on the tree organisation. Create a directory for your package, e.g.

   ```ShellSession
   $ mkdir pkgs/development/libraries/libfoo
   ```

3. In the package directory, create a Nix expression — a piece of code that describes how to build the package. In this case, it should be a _function_ that is called with the package dependencies as arguments, and returns a build of the package in the Nix store. The expression should usually be called `default.nix`.

   ```ShellSession
   $ emacs pkgs/development/libraries/libfoo/default.nix
   $ git add pkgs/development/libraries/libfoo/default.nix
   ```

   You can have a look at the existing Nix expressions under `pkgs/` to see how it’s done. Here are some good ones:

   - GNU Hello: [`pkgs/applications/misc/hello/default.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/hello/default.nix). Trivial package, which specifies some `meta` attributes which is good practice.

   - GNU cpio: [`pkgs/tools/archivers/cpio/default.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/archivers/cpio/default.nix). Also a simple package. The generic builder in `stdenv` does everything for you. It has no dependencies beyond `stdenv`.

   - GNU Multiple Precision arithmetic library (GMP): [`pkgs/development/libraries/gmp/5.1.x.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/gmp/5.1.x.nix). Also done by the generic builder, but has a dependency on `m4`.

   - Pan, a GTK-based newsreader: [`pkgs/applications/networking/newsreaders/pan/default.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/newsreaders/pan/default.nix). Has an optional dependency on `gtkspell`, which is only built if `spellCheck` is `true`.

   - Apache HTTPD: [`pkgs/servers/http/apache-httpd/2.4.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/http/apache-httpd/2.4.nix). A bunch of optional features, variable substitutions in the configure flags, a post-install hook, and miscellaneous hackery.

   - buildMozillaMach: [`pkgs/applications/networking/browser/firefox/common.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox/common.nix). A reusable build function for Firefox, Thunderbird and Librewolf.

   - JDiskReport, a Java utility: [`pkgs/tools/misc/jdiskreport/default.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/misc/jdiskreport/default.nix). Nixpkgs doesn’t have a decent `stdenv` for Java yet so this is pretty ad-hoc.

   - XML::Simple, a Perl module: [`pkgs/top-level/perl-packages.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/perl-packages.nix) (search for the `XMLSimple` attribute). Most Perl modules are so simple to build that they are defined directly in `perl-packages.nix`; no need to make a separate file for them.

   - Adobe Reader: [`pkgs/applications/misc/adobe-reader/default.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/adobe-reader/default.nix). Shows how binary-only packages can be supported. In particular the [builder](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/adobe-reader/builder.sh) uses `patchelf` to set the RUNPATH and ELF interpreter of the executables so that the right libraries are found at runtime.

   Some notes:

   - All [`meta`](#chap-meta) attributes are optional, but it’s still a good idea to provide at least the `description`, `homepage` and [`license`](#sec-meta-license).

   - You can use `nix-prefetch-url url` to get the SHA-256 hash of source distributions. There are similar commands as `nix-prefetch-git` and `nix-prefetch-hg` available in `nix-prefetch-scripts` package.

   - A list of schemes for `mirror://` URLs can be found in [`pkgs/build-support/fetchurl/mirrors.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/fetchurl/mirrors.nix).

   The exact syntax and semantics of the Nix expression language, including the built-in function, are described in the Nix manual in the [chapter on writing Nix expressions](https://hydra.nixos.org/job/nix/trunk/tarball/latest/download-by-type/doc/manual/#chap-writing-nix-expressions).

4. Add a call to the function defined in the previous step to [`pkgs/top-level/all-packages.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/all-packages.nix) with some descriptive name for the variable, e.g. `libfoo`.

   ```ShellSession
   $ emacs pkgs/top-level/all-packages.nix
   ```

   The attributes in that file are sorted by category (like “Development / Libraries”) that more-or-less correspond to the directory structure of Nixpkgs, and then by attribute name.

5. To test whether the package builds, run the following command from the root of the nixpkgs source tree:

   ```ShellSession
   $ nix-build -A libfoo
   ```

   where `libfoo` should be the variable name defined in the previous step. You may want to add the flag `-K` to keep the temporary build directory in case something fails. If the build succeeds, a symlink `./result` to the package in the Nix store is created.

6. If you want to install the package into your profile (optional), do

   ```ShellSession
   $ nix-env -f . -iA libfoo
   ```

7. Optionally commit the new package and open a pull request [to nixpkgs](https://github.com/NixOS/nixpkgs/pulls), or use [the Patches category](https://discourse.nixos.org/t/about-the-patches-category/477) on Discourse for sending a patch without a GitHub account.
