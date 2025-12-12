# Languages and frameworks {#chap-language-support}

The [standard build environment](#chap-stdenv) makes it easy to build typical Autotools-based packages with very little code. Any other kind of package can be accommodated by overriding the appropriate phases of `stdenv`. However, there are specialised functions in Nixpkgs to easily build packages for other programming languages, such as Perl or Haskell. These are described in this chapter.

Each supported language or software ecosystem has its own package set named `<language or ecosystem>Packages`, which can be explored in various ways:

- Search on [search.nixos.org](https://search.nixos.org/packages)

  For example, search for [`haskellPackages`](https://search.nixos.org/packages?query=haskellPackages) or [`rubyPackages`](https://search.nixos.org/packages?query=rubyPackages).

- Navigate attribute sets with [`nix repl`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-repl).

  This technique is generally useful to inspect Nix language data structures.

  :::{.example #example-navigte-nix-repl}

  # Navigate Java compiler variants in `javaPackages` with `nix repl`

  ```shell-session
  $ nix repl '<nixpkgs>' -I nixpkgs=channel:nixpkgs-unstable
  nix-repl> javaPackages.<tab>
  javaPackages.compiler               javaPackages.openjfx15              javaPackages.openjfx21              javaPackages.recurseForDerivations
  javaPackages.jogl_2_4_0             javaPackages.openjfx17              javaPackages.openjfx25
  javaPackages.mavenfod               javaPackages.openjfx19              javaPackages.override
  javaPackages.openjfx11              javaPackages.openjfx20              javaPackages.overrideDerivation
  ```
  :::

- List all derivations on the command line with [`nix-env --query`](https://nixos.org/manual/nix/stable/command-ref/nix-env/query).

  `nix-env` is the only convenient way to do that, as it will skip attributes that fail [assertions](https://nixos.org/manual/nix/stable/language/constructs#assertions), such as when a package is [marked as broken](#var-meta-broken), rather than failing the entire evaluation.

  :::{.example #example-list-haskellPackages}

  # List all Python packages in Nixpkgs

  The following command lists all [derivations names](https://nixos.org/manual/nix/stable/language/derivations#attr-name) with their attribute path from the latest Nixpkgs rolling release (`nixpkgs-unstable`).

  ```shell-session
  $ nix-env -qaP -f '<nixpkgs>' -A pythonPackages -I nixpkgs=channel:nixpkgs-unstable
  ```

  ```console
  pythonPackages.avahi                                                  avahi-0.8
  pythonPackages.boost                                                  boost-1.81.0
  pythonPackages.caffe                                                  caffe-1.0
  pythonPackages.caffeWithCuda                                          caffe-1.0
  pythonPackages.cbeams                                                 cbeams-1.0.3
  …
  ```
  :::

```{=include=} sections
agda.section.md
android.section.md
astal.section.md
beam.section.md
chicken.section.md
coq.section.md
cosmic.section.md
crystal.section.md
cuda.section.md
cuelang.section.md
dart.section.md
dhall.section.md
dlang.section.md
dotnet.section.md
emscripten.section.md
factor.section.md
gnome.section.md
go.section.md
gradle.section.md
hare.section.md
haskell.section.md
hy.section.md
idris.section.md
idris2.section.md
ios.section.md
java.section.md
javascript.section.md
julia.section.md
lisp.section.md
lua.section.md
maven.section.md
nim.section.md
ocaml.section.md
octave.section.md
perl.section.md
php.section.md
pkg-config.section.md
python.section.md
qt.section.md
r.section.md
ruby.section.md
rust.section.md
scheme.section.md
swift.section.md
tcl.section.md
texlive.section.md
typst.section.md
vim.section.md
neovim.section.md
```
