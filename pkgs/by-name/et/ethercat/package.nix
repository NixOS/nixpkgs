{
  autoreconfHook,
  callPackage,
  git,
  iproute2,
  kmod,
  lib,
  systemdMinimal,

  # For docs
  doxygen,
  fig2dev,
  graphviz,
  inkscape,
  python3,
  texlive,

  # Options
  withDocs ? false,
}:
let
  common = callPackage ./common.nix { inherit withDocs; };

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

    nativeBuildInputs =
      previousAttrs.nativeBuildInputs
      ++ lib.optionals withDocs [
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
      "out"
    ] ++ lib.optionals withDocs [ "doc" ];

    configureFlags = previousAttrs.configureFlags ++ [
      "--enable-tool=yes"
      "--enable-userlib=yes"
      "--enable-kernel=no"
      "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    ];

    # See: https://gitlab.com/etherlab.org/ethercat/-/blob/6e8119b95563ba955954a68e5e2f4f3f861ac72e/.gitlab-ci.yml#L117
    postPatch = lib.optionalString withDocs ''
      git show -s --format="\def\revision{%h}\def\gitversion{%(describe)}\def\gittag{%(describe:abbrev=0)}\def\gitauthor{%an}\def\isodate#1-#2-#3x{\day=#3 \month=#2 \year=#1}\isodate %csx" HEAD > documentation/git.tex
    '';

    postBuild = lib.optionalString withDocs ''
      echo "Build Doxygen docs"
      make doc

      echo "Build Doxygen LaTeX docs"
      make -C doxygen-output/latex

      echo "Build LateX manual"
      mkdir -p documentation/external
      make -C documentation
      make -C documentation index
      make -C documentation
    '';

    postInstall = lib.optionalString withDocs ''
      mkdir -p $doc/share/doc/
      cp -r doxygen-output/html $doc/share/doc/html
      cp -r doxygen-output/latex/refman.pdf $doc/share/doc/ethercat_ref.pdf
      cp documentation/*.pdf $doc/share/doc/
    '';

    postFixup = ''
      mv $out/{share,lib,etc} $bin
      sed -i \
        -e 's|=/sbin|=${kmod}/bin|' \
        -e 's|=/bin|=${iproute2}/bin|' \
        "$bin"/bin/ethercatctl
    '';
  }
)
