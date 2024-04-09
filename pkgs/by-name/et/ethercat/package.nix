{
  autoreconfHook,
  callPackage,
  doxygen,
  fig2dev,
  git,
  graphviz,
  inkscape,
  lib,
  python3,
  systemdMinimal,
  texlive,
}:
let
  common = callPackage ./common.nix { };

  tex = texlive.combine {
    inherit (texlive)
      collection-plaingeneric
      collection-latexrecommended
      collection-latexextra
      collection-fontsrecommended
      collection-fontutils
      siunits
      nomencl
      babel
      babel-french
      ;
  };
in
common.overrideAttrs (
  finalAttrs: previousAttrs: {
    buildInputs = [ systemdMinimal ];

    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
      doxygen
      fig2dev
      python3
      inkscape
      graphviz
      tex
      git
    ];

    outputs = [
      "bin"
      "dev"
      "doc"
      "out"
    ];

    configureFlags = previousAttrs.configureFlags ++ [
      "--enable-tool=yes"
      "--enable-userlib=yes"
      "--enable-kernel=no"
      "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    ];

    # See: https://gitlab.com/etherlab.org/ethercat/-/blob/6e8119b95563ba955954a68e5e2f4f3f861ac72e/.gitlab-ci.yml#L117
    postPatch = ''
      git show -s --format="\def\revision{%h}\def\gitversion{%(describe)}\def\gittag{%(describe:abbrev=0)}\def\gitauthor{%an}\def\isodate#1-#2-#3x{\day=#3 \month=#2 \year=#1}\isodate %csx" HEAD > documentation/git.tex
    '';

    postInstall = ''
      mkdir -p $doc

      echo "Build Doxygen docs"
      make doc
      cp -r doxygen-output/html $doc/html

      echo "Build Doxygen LaTeX docs"
      make -C doxygen-output/latex
      cp -r doxygen-output/latex/refman.pdf $doc/ethercat_ref.pdf

      echo "Build LateX manual"
      mkdir -p documentation/external
      make -C documentation
      make -C documentation index
      make -C documentation

      cp documentation/*.pdf $doc
    '';

    postFixup = ''
      mv $out/{share,lib,etc} $bin
    '';
  }
)
