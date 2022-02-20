{ lib, stdenv, fetchurl, coreutils, nettools, java, polyml, z3, veriT, vampire, eprover-ho, rlwrap, makeDesktopItem }:
# nettools needed for hostname

stdenv.mkDerivation rec {
  pname = "isabelle";
  version = "2021-1";

  dirname = "Isabelle${version}";

  src =
    if stdenv.isDarwin
    then
      fetchurl
        {
          url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_macos.tar.gz";
          sha256 = "0n1ls9vwf0ps1x8zpb7c1xz1wkasgvc34h5bz280hy2z6iqwmwbc";
        }
    else
      fetchurl {
        url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_linux.tar.gz";
        sha256 = "0jfaqckhg388jh9b4msrpkv6wrd6xzlw18m0bngbby8k8ywalp9i";
      };

  buildInputs = [ polyml z3 veriT vampire eprover-ho ]
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

    cat >contrib/verit-*/etc/settings <<EOF
      ISABELLE_VERIT=${veriT}/bin/veriT
    EOF

    cat >contrib/e-*/etc/settings <<EOF
      E_HOME=${eprover-ho}/bin
      E_VERSION=${eprover-ho.version}
    EOF

    cat >contrib/vampire-*/etc/settings <<EOF
      VAMPIRE_HOME=${vampire}/bin
      VAMPIRE_VERSION=${vampire.version}
      VAMPIRE_EXTRA_OPTIONS="--mode casc"
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

    for comp in contrib/jdk* contrib/polyml-* contrib/z3-* contrib/verit-* contrib/vampire-* contrib/e-*; do
      rm -rf $comp/x86*
    done

    substituteInPlace lib/Tools/env \
      --replace /usr/bin/env ${coreutils}/bin/env

    rm -r heaps
  '' + (if ! stdenv.isLinux then "" else ''
    arch=${if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64-linux" else "x86-linux"}
    for f in contrib/*/$arch/{bash_process,epclextract,nunchaku,SPASS,zipperposition}; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f"
    done
    for d in contrib/kodkodi-*/jni/$arch; do
      patchelf --set-rpath "${lib.concatStringsSep ":" [ "${java}/lib/openjdk/lib/server" "${stdenv.cc.cc.lib}/lib" ]}" $d/*.so
    done
  '');

  buildPhase = ''
    export HOME=$TMP # The build fails if home is not set
    bin/isabelle build -v -o system_heaps -b HOL
  '';

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
    maintainers = [ maintainers.jwiegley maintainers.jvanbruegge ];
    platforms = platforms.linux;
  };
}
