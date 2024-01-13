{ lib
, stdenv
, fetchurl
, coreutils
, nettools
, java
, scala_3
, polyml
, veriT
, vampire
, eprover-ho
, naproche
, rlwrap
, perl
, makeDesktopItem
, isabelle-components
, symlinkJoin
, fetchhg
}:

let
  sha1 = stdenv.mkDerivation {
    pname = "isabelle-sha1";
    version = "2021-1";

    src = fetchhg {
      url = "https://isabelle.sketis.net/repos/sha1";
      rev = "e0239faa6f42";
      sha256 = "sha256-4sxHzU/ixMAkSo67FiE6/ZqWJq9Nb9OMNhMoXH2bEy4=";
    };

    buildPhase = (if stdenv.isDarwin then ''
      LDFLAGS="-dynamic -undefined dynamic_lookup -lSystem"
    '' else ''
      LDFLAGS="-fPIC -shared"
    '') + ''
      CFLAGS="-fPIC -I."
      $CC $CFLAGS -c sha1.c -o sha1.o
      $LD $LDFLAGS sha1.o -o libsha1.so
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp libsha1.so $out/lib/
    '';
  };
in stdenv.mkDerivation (finalAttrs: rec {
  pname = "isabelle";
  version = "2023";

  dirname = "Isabelle${version}";

  src =
    if stdenv.isDarwin
    then
      fetchurl
        {
          url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_macos.tar.gz";
          sha256 = "sha256-0VSW2SrHNI3/k4cCCZ724ruXaq7W1NCPsLrXFZ9l1/Q=";
        }
    else if stdenv.hostPlatform.isx86
    then
      fetchurl {
        url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_linux.tar.gz";
        sha256 = "sha256-Go4ZCsDz5gJ7uWG5VLrNJOddMPX18G99FAadpX53Rqg=";
      }
    else
      fetchurl {
        url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_linux_arm.tar.gz";
        hash = "sha256-Tzxxs0gKw6vymbaXIzH8tK5VgUrpOIp9vcWQ/zxnRCc=";
      };

  nativeBuildInputs = [ java ];

  buildInputs = [ polyml veriT vampire eprover-ho nettools ]
    ++ lib.optionals (!stdenv.isDarwin) [ java ];

  sourceRoot = "${dirname}${lib.optionalString stdenv.isDarwin ".app"}";

  doCheck = stdenv.hostPlatform.system != "aarch64-linux";
  checkPhase = "bin/isabelle build -v HOL-SMT_Examples";

  postUnpack = lib.optionalString stdenv.isDarwin ''
    mv $sourceRoot ${dirname}
    sourceRoot=${dirname}
  '';

  postPatch = ''
    patchShebangs lib/Tools/ bin/

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

  '' + lib.optionalString stdenv.hostPlatform.isx86 ''
    rm contrib/naproche-*/x86*/Naproche-SAD
    ln -s ${naproche}/bin/Naproche-SAD contrib/naproche-*/x86*/
  '' + ''

    echo ISABELLE_LINE_EDITOR=${rlwrap}/bin/rlwrap >>etc/settings

    for comp in contrib/jdk* contrib/polyml-* contrib/verit-* contrib/vampire-* contrib/e-*; do
      rm -rf $comp/${if stdenv.hostPlatform.isx86 then "x86" else "arm"}*
    done

    substituteInPlace lib/Tools/env \
      --replace /usr/bin/env ${coreutils}/bin/env

    substituteInPlace src/Tools/Setup/src/Environment.java \
      --replace 'cmd.add("/usr/bin/env");' "" \
      --replace 'cmd.add("bash");' "cmd.add(\"$SHELL\");"

    substituteInPlace src/Pure/General/sha1.ML \
      --replace '"$ML_HOME/" ^ (if ML_System.platform_is_windows then "sha1.dll" else "libsha1.so")' '"${sha1}/lib/libsha1.so"'

    rm -r heaps
  '' + lib.optionalString (stdenv.hostPlatform.system == "x86_64-darwin") ''
    substituteInPlace lib/scripts/isabelle-platform \
      --replace 'ISABELLE_APPLE_PLATFORM64=arm64-darwin' ""
  '' + lib.optionalString stdenv.isLinux ''
    arch=${if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64-linux"
           else if stdenv.hostPlatform.isx86 then "x86-linux"
           else "arm64-linux"}
    for f in contrib/*/$arch/{z3,epclextract,nunchaku,SPASS,zipperposition}; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f"${lib.optionalString stdenv.isAarch64 " || true"}
    done
    patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) contrib/bash_process-*/platform_$arch/bash_process
    for d in contrib/kodkodi-*/jni/$arch; do
      patchelf --set-rpath "${lib.concatStringsSep ":" [ "${java}/lib/openjdk/lib/server" "${stdenv.cc.cc.lib}/lib" ]}" $d/*.so
    done
    patchelf --set-rpath "${stdenv.cc.cc.lib}/lib" contrib/z3-*/$arch/z3
  '';

  buildPhase = ''
    export HOME=$TMP # The build fails if home is not set
    setup_name=$(basename contrib/isabelle_setup*)

    #The following is adapted from https://isabelle.sketis.net/repos/isabelle/file/Isabelle2021-1/Admin/lib/Tools/build_setup
    TARGET_DIR="contrib/$setup_name/lib"
    rm -rf "$TARGET_DIR"
    mkdir -p "$TARGET_DIR/isabelle/setup"
    declare -a ARGS=("-Xlint:unchecked")

    SOURCES="$(${perl}/bin/perl -e 'while (<>) { if (m/(\S+\.java)/)  { print "$1 "; } }' "src/Tools/Setup/etc/build.props")"
    for SRC in $SOURCES
    do
      ARGS["''${#ARGS[@]}"]="src/Tools/Setup/$SRC"
    done
    echo "Building isabelle setup"
    javac -d "$TARGET_DIR" -classpath "${scala_3.bare}/lib/scala3-interfaces-${scala_3.version}.jar:${scala_3.bare}/lib/scala3-compiler_3-${scala_3.version}.jar" "''${ARGS[@]}"
    jar -c -f "$TARGET_DIR/isabelle_setup.jar" -e "isabelle.setup.Setup" -C "$TARGET_DIR" isabelle
    rm -rf "$TARGET_DIR/isabelle"

    echo "Building HOL heap"
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
    categories = [ "Education" "Science" "Math" ];
  };

  meta = with lib; {
    description = "A generic proof assistant";

    longDescription = ''
      Isabelle is a generic proof assistant.  It allows mathematical formulas
      to be expressed in a formal language and provides tools for proving those
      formulas in a logical calculus.
    '';
    homepage = "https://isabelle.in.tum.de/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode  # source bundles binary dependencies
    ];
    license = licenses.bsd3;
    maintainers = [ maintainers.jwiegley maintainers.jvanbruegge ];
    platforms = platforms.unix;
  };

  passthru.withComponents = f:
    let
      isabelle = finalAttrs.finalPackage;
      base = "$out/${isabelle.dirname}";
      components = f isabelle-components;
    in symlinkJoin {
      name = "isabelle-with-components-${isabelle.version}";
      paths = [ isabelle ] ++ (builtins.map (c: c.override { inherit isabelle; }) components);

      postBuild = ''
        rm $out/bin/*

        cd ${base}
        rm bin/*
        cp ${isabelle}/${isabelle.dirname}/bin/* bin/
        rm etc/components
        cat ${isabelle}/${isabelle.dirname}/etc/components > etc/components

        export HOME=$TMP
        bin/isabelle install $out/bin
        patchShebangs $out/bin
      '' + lib.concatMapStringsSep "\n" (c: ''
        echo contrib/${c.pname}-${c.version} >> ${base}/etc/components
      '') components;
    };
})
