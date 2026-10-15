{
  lib,
  stdenv,
  polyml,
  fetchFromGitHub,
  graphviz,
  fontconfig,
  liberation_ttf,
  mlton,
  experimentalKernel ? false,
}:

let
  versionBase = "trindemossen-2";
  kernelFlag = if experimentalKernel then "--expk" else "--stdknl";
  # the current version of mlton doesn't support i686-linux
  # it also fails to build with musl
  useMlton =
    stdenv.buildPlatform.system != "i686-linux"
    && stdenv.hostPlatform.system != "i686-linux"
    && !stdenv.buildPlatform.isMusl
    && !stdenv.hostPlatform.isMusl
    && lib.elem stdenv.buildPlatform.system mlton.meta.platforms
    && lib.elem stdenv.hostPlatform.system mlton.meta.platforms;
in

stdenv.mkDerivation {
  pname = "hol";
  version = "4-${versionBase}";

  src = fetchFromGitHub {
    owner = "HOL-Theorem-Prover";
    repo = "HOL";
    tag = versionBase;
    hash = "sha256-esgqSlQ4M2DLNu02aALetuPJYsV/1RSEv65tEeVNno0=";
  };

  buildInputs = [
    polyml
    graphviz
    fontconfig
    liberation_ttf
  ]
  ++ lib.optional useMlton mlton;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace tools/editor-modes/emacs/hol-mode.src \
      --replace-fail "/tools/yasnippets" "/tools/editor-modes/emacs/yasnippets"
  '';

  configurePhase = ''
    mkdir chroot-fontconfig
    cat ${fontconfig.out}/etc/fonts/fonts.conf > chroot-fontconfig/fonts.conf
    sed -e 's@</fontconfig>@@' -i chroot-fontconfig/fonts.conf
    echo "<dir>${liberation_ttf}</dir>" >> chroot-fontconfig/fonts.conf
    echo "</fontconfig>" >> chroot-fontconfig/fonts.conf

    export FONTCONFIG_FILE=$(pwd)/chroot-fontconfig/fonts.conf
  '';

  installPhase = ''
    mkdir -p "$out/share/hol"

    cp -a . "$out/share/hol"
    cd "$out/share/hol"

    rm -rf chroot-fontconfig .github .gitignore .gitattributes developers \
           examples/dev/sw examples/muddy/MuddyC/buddy/doc/{buddy,bddnotes}.ps \
           examples/pgcl Manual
    find . -type f -name ".gitignore" -print0 | xargs -0 rm

    poly < tools/smart-configure.sml

    # Extra theories we want to build
    echo 'examples/formal-languages/context-free' >> tools/sequences/final-examples

    # We run `bin/build` twice to force HOL to generate `.hol/make-deps/*Theory.{sml,sig}.d` files
    # See https://github.com/HOL-Theorem-Prover/HOL/issues/1670 for more info
    bin/build ${kernelFlag} -j $NIX_BUILD_CORES
    bin/build ${kernelFlag} -j $NIX_BUILD_CORES

    mkdir -p "$out/bin"
    ln -st "$out/bin" "$out"/share/hol/bin/*
  '';

  meta = {
    description = "Interactive theorem prover based on Higher-Order Logic";
    longDescription = ''
      HOL4 is the latest version of the HOL interactive proof
      assistant for higher order logic: a programming environment in
      which theorems can be proved and proof tools
      implemented. Built-in decision procedures and theorem provers
      can automatically establish many simple theorems (users may have
      to prove the hard theorems themselves!) An oracle mechanism
      gives access to external programs such as SMT and BDD
      engines. HOL4 is particularly suitable as a platform for
      implementing combinations of deduction, execution and property
      checking.
    '';
    homepage = "https://hol-theorem-prover.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mudri ];
  };
}
