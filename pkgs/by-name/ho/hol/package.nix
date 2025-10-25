{
  lib,
  stdenv,
  pkgs,
  fetchurl,
  graphviz,
  fontconfig,
  liberation_ttf,
  mlton,
  experimentalKernel ? false,
}:

let
  pname = "hol4";
  vnum = "2";

  version = "t.${vnum}";
  longVersion = "trindemossen-${vnum}";
  holsubdir = "hol-${longVersion}";
  kernelFlag = if experimentalKernel then "--expk" else "--stdknl";
  buildSys = stdenv.buildPlatform.system;
  hostSys = stdenv.hostPlatform.system;
  # the current version of mlton doesn't support i686-linux
  # it also fails to build with musl
  useMlton =
    buildSys != "i686-linux"
    && hostSys != "i686-linux"
    && !stdenv.buildPlatform.isMusl
    && !stdenv.hostPlatform.isMusl
    && lib.elem buildSys mlton.meta.platforms
    && lib.elem hostSys mlton.meta.platforms;

  polymlEnableShared =
    with pkgs;
    lib.overrideDerivation polyml (attrs: {
      configureFlags = [ "--enable-shared" ];
    });
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/HOL-Theorem-Prover/HOL/releases/download/${longVersion}/${holsubdir}.tar.gz";
    hash = "sha256-Ciy6IaB7LqwKlZOnEw1H1IcVoSL/bfbQxoWPcZD3H3w=";
  };

  buildInputs = [
    polymlEnableShared
    graphviz
    fontconfig
    liberation_ttf
  ]
  ++ lib.optional useMlton mlton;

  enableParallelBuilding = true;

  buildPhase = ''
    mkdir chroot-fontconfig
    cat ${fontconfig.out}/etc/fonts/fonts.conf > chroot-fontconfig/fonts.conf
    sed -e 's@</fontconfig>@@' -i chroot-fontconfig/fonts.conf
    echo "<dir>${liberation_ttf}</dir>" >> chroot-fontconfig/fonts.conf
    echo "</fontconfig>" >> chroot-fontconfig/fonts.conf

    export FONTCONFIG_FILE=$(pwd)/chroot-fontconfig/fonts.conf

    mkdir -p "$out/src"

    cp -a . "$out/src"
    cd "$out/src"

    poly < tools/smart-configure.sml

    jobs=''${enableParallelBuilding:+$NIX_BUILD_CORES}

    # Extra theories we want to build
    echo 'examples/formal-languages/context-free' >> tools/sequences/final-examples

    # We run `bin/build` twice to force HOL to generate `.hol/make-deps/*Theory.{sml,sig}.d` files
    # See https://github.com/HOL-Theorem-Prover/HOL/issues/1670 for more info
    bin/build ${kernelFlag} -j ''${jobs:-1}
    bin/build ${kernelFlag} -j ''${jobs:-1}
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    ln -st "$out/bin" "$out"/src/bin/*
  '';

  meta = with lib; {
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
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mudri ];
  };
}
