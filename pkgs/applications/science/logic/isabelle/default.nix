{ lib, stdenv, fetchurl, perl, perlPackages, makeWrapper, nettools, java, polyml, z3, rlwrap, makeDesktopItem }:
# nettools needed for hostname

stdenv.mkDerivation rec {
  pname = "isabelle";
  version = "2021";

  dirname = "Isabelle${version}";

  src = if stdenv.isDarwin
    then fetchurl {
      url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_macos.tar.gz";
      sha256 = "1c2qm2ksmpyxyccyyn4lyj2wqj5m74nz2i0c5abrd1hj45zcnh1m";
    }
    else fetchurl {
      url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_linux.tar.gz";
      sha256 = "1isgc9w4q95638dcag9gxz1kmf97pkin3jz1dm2lhd64b2k12y2x";
    };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl polyml z3 ]
             ++ lib.optionals (!stdenv.isDarwin) [ nettools java ];

  sourceRoot = dirname;

  postPatch = ''
    patchShebangs .

    cat >contrib/z3*/etc/settings <<EOF
      Z3_HOME=${z3}
      Z3_VERSION=${z3.version}
      Z3_SOLVER=${z3}/bin/z3
      Z3_INSTALLED=yes
    EOF

    cat >contrib/polyml-*/etc/settings <<EOF
      ML_SYSTEM_64=true
      ML_SYSTEM=${polyml.name}
      ML_PLATFORM=${stdenv.system}
      ML_HOME=${polyml}/bin
      ML_OPTIONS="--minheap 1000"
      POLYML_HOME="\$COMPONENT"
      ML_SOURCES="\$POLYML_HOME/src"
    EOF

    cat >contrib/jdk*/etc/settings <<EOF
      ISABELLE_JAVA_PLATFORM=${stdenv.system}
      ISABELLE_JDK_HOME=${java}
    EOF

    sed -i -e 's/naproche_server : bool = true/naproche_server : bool = false/' contrib/naproche-*/etc/options

    echo ISABELLE_LINE_EDITOR=${rlwrap}/bin/rlwrap >>etc/settings

    for comp in contrib/jdk* contrib/polyml-* contrib/z3-*; do
      rm -rf $comp/x86*
    done
    '' + (if ! stdenv.isLinux then "" else ''
    arch=${if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64-linux" else "x86-linux"}
    for f in contrib/*/$arch/{bash_process,epclextract,eprover,nunchaku,SPASS}; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f"
    done
    '');

  installPhase = ''
    mkdir -p $out/bin
    mv $TMP/$dirname $out
    cd $out/$dirname
    bin/isabelle install $out/bin

    # icon
    mkdir -p "$out/share/icons/hicolor/isabelle/apps"
    cp "$out/Isabelle${version}/lib/icons/isabelle.xpm" "$out/share/icons/hicolor/isabelle/apps/"

    # desktop item
    mkdir -p "$out/share"
    cp -r "${desktopItem}/share/applications" "$out/share/applications"

    wrapProgram $out/$dirname/src/HOL/Tools/ATP/scripts/remote_atp --set PERL5LIB ${perlPackages.makeFullPerlPath [ perlPackages.LWP ]}
  '';

  desktopItem = makeDesktopItem {
    name = "isabelle";
    exec = "isabelle jedit";
    icon = "isabelle";
    desktopName = "Isabelle";
    comment = meta.description;
    categories = "Education;Science;Math;";
  };

  meta = with lib; {
    description = "A generic proof assistant";

    longDescription = ''
      Isabelle is a generic proof assistant.  It allows mathematical formulas
      to be expressed in a formal language and provides tools for proving those
      formulas in a logical calculus.
    '';
    homepage = "https://isabelle.in.tum.de/";
    license = licenses.bsd3;
    maintainers = [ maintainers.jwiegley ];
    platforms = platforms.linux;
  };
}
