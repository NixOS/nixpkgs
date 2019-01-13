{stdenv, pkgs, fetchFromGitHub, graphviz, fontconfig, liberation_ttf, gmp,
 experimentalKernel ? true}:

let
  pname = "hol4";
  vnum = "12";
in

let
  version = "k.${vnum}";
  kernelFlag = if experimentalKernel then "-expk" else "-stdknl";
in

let
  polymlEnableShared = with pkgs; lib.overrideDerivation polyml (attrs: {
    configureFlags = [ "--enable-shared" ];
  });
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "HOL-Theorem-Prover";
    repo = "HOL";
    sha256 = "0hdxrgava85gk713pixmlcv099bsrcgc6sh4slwqjdh3zif57bcm";
    rev = "26e80a62cb4b3b7d64dea8531041adb2494342a2";
    # date = 2019-01-10T03:14:10+01:00;
  };

  buildInputs = [polymlEnableShared graphviz fontconfig liberation_ttf gmp];

  buildPhase = ''
    mkdir chroot-fontconfig
    cat ${fontconfig.out}/etc/fonts/fonts.conf > chroot-fontconfig/fonts.conf
    sed -e 's@</fontconfig>@@' -i chroot-fontconfig/fonts.conf
    echo "<dir>${liberation_ttf}</dir>" >> chroot-fontconfig/fonts.conf
    echo "</fontconfig>" >> chroot-fontconfig/fonts.conf

    export FONTCONFIG_FILE=$(pwd)/chroot-fontconfig/fonts.conf

    substituteInPlace tools/Holmake/Holmake_types.sml \
      --replace "\"/bin/mv\"" "\"mv\"" \
      --replace "\"/bin/cp\"" "\"cp\""

    substituteInPlace src/HolSat/sat_solvers/zc2hs/Makefile \
      --replace "g++" "${stdenv.cc.targetPrefix}c++"
    substituteInPlace src/HolSat/sat_solvers/minisat/Makefile \
      --replace "g++" "${stdenv.cc.targetPrefix}c++"
    substituteInPlace tools/Holmake/Holmake_tools.sml \
      --replace "if Systeml.isUnix then xterm_log" \
                "if false then xterm_log"

    poly < tools/smart-configure.sml

    #bin/build ${kernelFlag} -symlink
    bin/build

    mkdir -p $out/bin
    cp -p bin/hol $out/bin
  '';

  meta = with stdenv.lib; {
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
    homepage = http://hol.sourceforge.net/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mudri ];
    platforms = with platforms; unix;
  };
}
