{
  lib,
  stdenv,
  fetchFromGitHub,
  nawk,
  groff,
  icon-lang,
  useIcon ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noweb";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "nrnrnr";
    repo = "noweb";
    rev = "v${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    sha256 = "sha256-COcWyrYkheRaSr2gqreRRsz9SYRTX2PSl7km+g98ljs=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    # Remove FAQ
    ./no-FAQ.patch
  ];

  postPatch = ''
    substituteInPlace Makefile --replace 'strip' '${stdenv.cc.targetPrefix}strip'
    substituteInPlace Makefile --replace '`./gitversion`' '${finalAttrs.src.rev}'
  '';

  nativeBuildInputs = [ groff ] ++ lib.optionals useIcon [ icon-lang ];
  buildInputs = [ nawk ];

  preBuild = ''
    mkdir -p "$out/lib/noweb"
  '';

  makeFlags =
    lib.optionals useIcon [
      "LIBSRC=icon"
      "ICONC=icont"
    ]
    ++ [ "CC=${stdenv.cc.targetPrefix}cc" ];

  preInstall = ''
    mkdir -p "$tex/tex/latex/noweb"
    installFlagsArray+=(                                   \
        "BIN=${placeholder "out"}/bin"                     \
        "ELISP=${placeholder "out"}/share/emacs/site-lisp" \
        "LIB=${placeholder "out"}/lib/noweb"               \
        "MAN=${placeholder "out"}/share/man"               \
        "TEXINPUTS=${placeholder "tex"}/tex/latex/noweb"   \
    )
  '';

  installTargets = [
    "install-code"
    "install-tex"
    "install-elisp"
  ];

  postInstall = ''
    substituteInPlace "$out/bin/cpif" --replace "PATH=/bin:/usr/bin" ""

    for f in $out/bin/no{index,roff,roots,untangle,web} \
             $out/lib/noweb/to{ascii,html,roff,tex} \
             $out/lib/noweb/{bt,empty}defn \
             $out/lib/noweb/{noidx,pipedocs,unmarkup}; do
        # NOTE: substituteInPlace breaks Icon binaries, so make sure the script
        #       uses (n)awk before calling.
        if grep -q nawk "$f"; then
            substituteInPlace "$f" --replace "nawk" "${nawk}/bin/nawk"
        fi
    done

    # HACK: This is ugly, but functional.
    PATH=$out/bin:$PATH make -BC xdoc
    make "''${installFlagsArray[@]}" install-man

    ln -s "$tex" "$out/share/texmf"
  '';

  outputs = [
    "out"
    "tex"
  ];

  passthru = {
    tlType = "run";
    pkgs = [ finalAttrs.finalPackage.tex ];
  };

  meta = with lib; {
    description = "Simple, extensible literate-programming tool";
    homepage = "https://www.cs.tufts.edu/~nr/noweb";
    license = licenses.bsd2;
    maintainers = with maintainers; [ yurrriq ];
    platforms = with platforms; linux ++ darwin;
  };
})
