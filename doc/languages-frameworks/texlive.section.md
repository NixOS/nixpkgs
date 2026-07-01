# TeX Live {#sec-language-texlive}

There is a TeX Live packaging that lives entirely under attribute `texlive`.

## User's guide {#sec-language-texlive-user-guide}

- For basic usage, use some of the prebuilt environments available at the top level, such as `texliveBasic`, `texliveSmall`. For the full list of prebuilt environments, inspect `texlive.schemes`.

- Packages cannot be used directly but must be assembled in an environment. To create or add packages to an environment, use
  ```nix
  texliveSmall.withPackages (
    ps: with ps; [
      collection-langkorean
      algorithms
      cm-super
    ]
  )
  ```
  The function `withPackages` can be called multiple times to add more packages.

  - **Note.** Within Nixpkgs, packages should only use prebuilt environments as inputs, such as `texliveSmall` or `texliveInfraOnly`, and should not depend directly on `texlive`. Further dependencies should be added by calling `withPackages`. This is to ensure that there is a consistent and simple way to override the inputs.

- `texlive.withPackages` uses the same logic as `buildEnv`. Only parts of a package are installed in an environment: its 'runtime' files (`tex` output), binaries (`out` output), and support files (`tlpkg` output). Moreover, man and info pages are assembled into separate `man` and `info` outputs. To add only the TeX files of a package, or its documentation (`texdoc` output), just specify the outputs:
  ```nix
  texliveBasic.withPackages (
    ps: with ps; [
      texdoc # recommended package to navigate the documentation
      perlPackages.LaTeXML.tex # tex files of LaTeXML, omit binaries
      cm-super
      cm-super.texdoc # documentation of cm-super
    ]
  )
  ```

- To add the documentation for all packages in the environment, use
  ```nix
  texliveSmall.overrideAttrs { withDocs = true; }
  ```
  This can be applied before or after calling `withPackages`. The parameter `withSources` adds all source containers.

- All packages distributed by TeX Live, which contains most of CTAN, are available and can be found under `texlive.pkgs`:
  ```ShellSession
  $ nix repl
  nix-repl> :l <nixpkgs>
  nix-repl> texlive.pkgs.[TAB]
  ```
  These are derivations with outputs `out`, `tex`, `texdoc`, `texsource`, `tlpkg`, `man`, `info`. They cannot be installed outside of `texlive.withPackages` but are available for other uses. To repackage a font, for instance, use

  ```nix
  stdenvNoCC.mkDerivation (finalAttrs: {
    src = texlive.pkgs.iwona;
    dontUnpack = true;

    inherit (finalAttrs.src) pname version;

    installPhase = ''
      runHook preInstall
      install -Dm644 $src/fonts/opentype/nowacki/iwona/*.otf -t $out/share/fonts/opentype
      runHook postInstall
    '';
  })
  ```

  See `biber`, `iwona` for complete examples.

## Custom packages {#sec-language-texlive-custom-packages}

You may find that you need to use an external TeX package. A derivation for such package has to provide the contents of the "texmf" directory in its `"tex"` output, according to the [TeX Directory Structure](https://tug.ctan.org/tds/tds.html). Dependencies on other TeX packages can be listed in the attribute `passthru.tlDeps`, which is a function taking a package set and returning a list of packages.

The function `texlive.withPackages` recognise the following outputs:

- `"out"`: contents are linked in the TeX Live environment, and binaries in the `$out/bin` folder are wrapped;
- `"tex"`: linked in `$TEXMFDIST`; files should follow the TDS (for instance `$tex/tex/latex/foiltex/foiltex.cls`);
- `"texdoc"`, `"texsource"`: ignored by default, treated as `"tex"`;
- `"tlpkg"`: linked in `$TEXMFROOT/tlpkg`;
- `"man"`, `"info"`, ...: the other outputs are combined into separate outputs.

Here is a (very verbose) example. See also the packages `auctex`, `eukleides`, `mftrace` for more examples.

```nix
with import <nixpkgs> { };

let
  foiltex = stdenvNoCC.mkDerivation {
    pname = "latex-foiltex";
    version = "2.1.4b";

    outputs = [
      "tex"
      "texdoc"
    ];
    passthru.tlDeps = ps: [ ps.latex ];

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

    nativeBuildInputs = [
      (texliveSmall.withPackages (
        ps: with ps; [
          cm-super
          hypdoc
          latexmk
        ]
      ))
      writableTmpDirAsHomeHook # Need a writable $HOME for latexmk
    ];

    # multiple-outputs.sh fails if $out is not defined
    preHook = ''
      out="''${tex-}"
    '';

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      # Generate the style files
      latex foiltex.ins

      # Generate the documentation
      latexmk -pdf foiltex.dtx

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      path="$tex/tex/latex/foiltex"
      mkdir -p "$path"
      cp *.{cls,def,clo,sty} "$path/"

      path="$texdoc/doc/tex/latex/foiltex"
      mkdir -p "$path"
      cp *.pdf "$path/"

      runHook postInstall
    '';

    meta = {
      description = "LaTeX2e class for overhead transparencies";
      license = lib.licenses.unfreeRedistributable;
      maintainers = with lib.maintainers; [ veprbl ];
      platforms = lib.platforms.all;
    };
  };

  latex_with_foiltex = texliveSmall.withPackages (_: [ foiltex ]);
in
runCommand "test.pdf" { nativeBuildInputs = [ latex_with_foiltex ]; } ''
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

## LuaLaTeX font cache {#sec-language-texlive-lualatex-font-cache}

The font cache for LuaLaTeX is written to `$HOME`.
Therefore, it is necessary to set `$HOME` to a writable path, e.g. [before using LuaLaTeX in nix derivations](https://github.com/NixOS/nixpkgs/issues/180639):
```nix
runCommand "lualatex-hello-world" { buildInputs = [ texliveFull ]; } ''
  mkdir $out
  echo '\documentclass{article} \begin{document} Hello world \end{document}' > main.tex
  env HOME=$(mktemp -d) lualatex  -interaction=nonstopmode -output-format=pdf -output-directory=$out ./main.tex
''
```

Additionally, [the cache of a user can diverge from the nix store](https://github.com/NixOS/nixpkgs/issues/278718).
To resolve font issues that might follow, the cache can be removed by the user:
```ShellSession
luaotfload-tool --cache=erase --flush-lookups --force
```
