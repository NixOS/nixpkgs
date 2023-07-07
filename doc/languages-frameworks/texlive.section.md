# TeX Live {#sec-language-texlive}

Since release 15.09 there is a new TeX Live packaging that lives entirely under attribute `texlive`.

## User's guide {#sec-language-texlive-user-guide}

- For basic usage just pull `texlive.combined.scheme-basic` for an environment with basic LaTeX support.

- It typically won't work to use separately installed packages together. Instead, you can build a custom set of packages like this. Most CTAN packages should be available:

  ```nix
  texlive.combine {
    inherit (texlive) scheme-small collection-langkorean algorithms cm-super;
  }
  ```

- There are all the schemes, collections and a few thousand packages, as defined upstream (perhaps with tiny differences).

- By default you only get executables and files needed during runtime, and a little documentation for the core packages. To change that, you need to add `pkgFilter` function to `combine`.

  ```nix
  texlive.combine {
    # inherit (texlive) whatever-you-want;
    pkgFilter = pkg:
      pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "cm-super";
    # elem tlType [ "run" "bin" "doc" "source" ]
    # there are also other attributes: version, name
  }
  ```

- You can list packages e.g. by `nix repl`.

  ```ShellSession
  $ nix repl
  nix-repl> :l <nixpkgs>
  nix-repl> texlive.collection-[TAB]
  ```

- Note that the wrapper assumes that the result has a chance to be useful. For example, the core executables should be present, as well as some core data files. The supported way of ensuring this is by including some scheme, for example `scheme-basic`, into the combination.

## Custom packages {#sec-language-texlive-custom-packages}

You may find that you need to use an external TeX package. A derivation for such package has to provide the contents of the "texmf" directory in its output and provide the appropriate `tlType` attribute (one of `"run"`, `"bin"`, `"doc"`, `"source"`). Dependencies on other TeX packages can be listed in the attribute `tlDeps`.

Such derivation must then be listed in the attribute `pkgs` of an attribute set passed to `texlive.combine`, for instance by passing `extraPkgs = { pkgs = [ custom_package ]; };`. Within Nixpkgs, `pkgs` should be part of the derivation itself, allowing users to call `texlive.combine { inherit (texlive) scheme-small; inherit some_tex_package; }`.

Here is a (very verbose) example where the attribute `pkgs` is attached to the derivation itself, which requires creating a fixed point. See also the packages `auctex`, `eukleides`, `mftrace` for more examples.

```nix
with import <nixpkgs> {};

let
  foiltex = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "latex-foiltex";
    version = "2.1.4b";
    passthru = {
      pkgs = [ finalAttrs.finalPackage ];
      tlDeps = with texlive; [ latex ];
      tlType = "run";
    };

    srcs = [
      (fetchurl {
        url = "http://mirrors.ctan.org/macros/latex/contrib/foiltex/foiltex.dtx";
        hash = "sha256-/2I2xHXpZi0S988uFsGuPV6hhMw8e0U5m/P8myf42R0=";
      })
      (fetchurl {
        url = "http://mirrors.ctan.org/macros/latex/contrib/foiltex/foiltex.ins";
        hash = "sha256-KTm3pkd+Cpu0nSE2WfsNEa56PeXBaNfx/sOO2Vv0kyc=";
      })
    ];

    unpackPhase = ''
      runHook preUnpack

      for _src in $srcs; do
        cp "$_src" $(stripHash "$_src")
      done

      runHook postUnpack
    '';

    nativeBuildInputs = [ texlive.combined.scheme-small ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      # Generate the style files
      latex foiltex.ins

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      path="$out/tex/latex/foiltex"
      mkdir -p "$path"
      cp *.{cls,def,clo} "$path/"

      runHook postInstall
    '';

    meta = with lib; {
      description = "A LaTeX2e class for overhead transparencies";
      license = licenses.unfreeRedistributable;
      maintainers = with maintainers; [ veprbl ];
      platforms = platforms.all;
    };
  });

  latex_with_foiltex = texlive.combine {
    inherit (texlive) scheme-small;
    inherit foiltex;
  };
in
  runCommand "test.pdf" {
    nativeBuildInputs = [ latex_with_foiltex ];
  } ''
cat >test.tex <<EOF
\documentclass{foils}

\title{Presentation title}
\date{}

\begin{document}
\maketitle
\end{document}
EOF
  pdflatex test.tex
  cp test.pdf $out
''
```
