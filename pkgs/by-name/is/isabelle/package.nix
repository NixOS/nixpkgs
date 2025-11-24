{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  coreutils,
  net-tools,
  java,
  scala_3,
  polyml,
  verit,
  vampire,
  eprover-ho,
  rlwrap,
  perl,
  procps,
  makeDesktopItem,
  isabelle-components,
  symlinkJoin,
  fetchhg,
}:

let
  vampire' = vampire.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "vprover";
      repo = "vampire";
      tag = "v4.8HO4Sledgahammer";
      hash = "sha256-CmppaGa4M9tkE1b25cY1LSPFygJy5yV4kpHKbPqvcVE=";
    };
  });

  sha1 = stdenv.mkDerivation {
    pname = "isabelle-sha1";
    version = "2024";

    src = fetchhg {
      url = "https://isabelle.sketis.net/repos/sha1";
      rev = "0ce12663fe76";
      hash = "sha256-DB/ETVZhbT82IMZA97TmHG6gJcGpFavxDKDTwPzIF80=";
    };

    buildPhase = ''
      CFLAGS="-fPIC -I."
      LDFLAGS="-fPIC -shared"
      $CC $CFLAGS -c sha1.c -o sha1.o
      $CC $LDFLAGS sha1.o -o libsha1.so
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp libsha1.so $out/lib/
    '';
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "isabelle";
  version = "2025";

  dirname = "Isabelle${finalAttrs.version}";

  src =
    if stdenv.hostPlatform.isDarwin then
      fetchurl {
        url = "https://isabelle.in.tum.de/website-${finalAttrs.dirname}/dist/${finalAttrs.dirname}_macos.tar.gz";
        hash = "sha256-6ldUwiiFf12dOuJU7JgUeX8kU+opDfILL23LLvDi5/g=";
      }
    else if stdenv.hostPlatform.isx86 then
      fetchurl {
        url = "https://isabelle.in.tum.de/website-${finalAttrs.dirname}/dist/${finalAttrs.dirname}_linux.tar.gz";
        hash = "sha256-PR1m3jcYI/4xqormZjj3NXW6wkTwCzGu4dy2LzgUfFY=";
      }
    else
      fetchurl {
        url = "https://isabelle.in.tum.de/website-${finalAttrs.dirname}/dist/${finalAttrs.dirname}_linux_arm.tar.gz";
        hash = "sha256-p/Hp+7J5gJy5s6BVD5Ma1Mu2OS53I8BS7gKSOYYB0PE=";
      };

  nativeBuildInputs = [ java ];

  buildInputs = [
    polyml
    verit
    vampire'
    eprover-ho
    net-tools
  ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ procps ];

  sourceRoot = "${finalAttrs.dirname}${lib.optionalString stdenv.hostPlatform.isDarwin ".app"}";

  doCheck = stdenv.hostPlatform.system != "aarch64-linux";
  checkPhase = "bin/isabelle build -v HOL-SMT_Examples";

  postUnpack = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv $sourceRoot ${finalAttrs.dirname}
    sourceRoot=${finalAttrs.dirname}
  '';

  postPatch = ''
    patchShebangs lib/Tools/ bin/

    cat >contrib/verit-*/etc/settings <<EOF
      ISABELLE_VERIT=${verit}/bin/veriT
    EOF

    cat >contrib/e-*/etc/settings <<EOF
      E_HOME=${eprover-ho}/bin
      E_VERSION=${eprover-ho.version}
    EOF

    cat >contrib/vampire-*/etc/settings <<EOF
      VAMPIRE_HOME=${vampire'}/bin
      VAMPIRE_VERSION=${vampire'.version}
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

    echo ISABELLE_LINE_EDITOR=${rlwrap}/bin/rlwrap >>etc/settings

    for comp in contrib/jdk* contrib/polyml-* contrib/verit-* contrib/vampire-* contrib/e-*; do
      rm -rf $comp/${if stdenv.hostPlatform.isx86 then "x86" else "arm"}*
    done
    rm -rf contrib/*/src

    substituteInPlace lib/Tools/env \
      --replace-fail /usr/bin/env ${coreutils}/bin/env

    substituteInPlace src/Tools/Setup/src/Environment.java \
      --replace-fail 'cmd.add("/usr/bin/env");' "" \
      --replace-fail 'cmd.add("bash");' "cmd.add(\"$SHELL\");"

    substituteInPlace src/Pure/General/sha1.ML \
      --replace-fail '"$ML_HOME/" ^ (if ML_System.platform_is_windows then "sha1.dll" else "libsha1.so")' '"${sha1}/lib/libsha1.so"'

    rm -r heaps
  ''
  + lib.optionalString (stdenv.hostPlatform.system == "x86_64-darwin") ''
    substituteInPlace lib/scripts/isabelle-platform \
      --replace-fail 'ISABELLE_APPLE_PLATFORM64=arm64-darwin' ""
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    arch=${
      if stdenv.hostPlatform.system == "aarch64-linux" then "arm64-linux" else stdenv.hostPlatform.system
    }
    for f in contrib/*/$arch/{z3,nunchaku,spass,zipperposition}; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f"${lib.optionalString stdenv.hostPlatform.isAarch64 " || true"}
    done
    patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) contrib/bash_process-*/$arch/bash_process
    for d in contrib/kodkodi-*/jni/$arch; do
      patchelf --set-rpath "${
        lib.concatStringsSep ":" [
          "${java}/lib/openjdk/lib/server"
          "${lib.getLib stdenv.cc.cc}/lib"
        ]
      }" $d/*.so
    done
  ''
  + lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
    patchelf --set-rpath "${lib.getLib stdenv.cc.cc}/lib" contrib/z3-*/$arch/z3
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
    cp "$out/Isabelle${finalAttrs.version}/lib/icons/isabelle.xpm" "$out/share/icons/hicolor/isabelle/apps/"

    # desktop item
    mkdir -p "$out/share"
    cp -r "${finalAttrs.desktopItem}/share/applications" "$out/share/applications"
  '';

  desktopItem = makeDesktopItem {
    name = "isabelle";
    exec = "isabelle jedit";
    icon = "isabelle";
    desktopName = "Isabelle";
    comment = finalAttrs.meta.description;
    categories = [
      "Education"
      "Science"
      "Math"
    ];
  };

  meta = with lib; {
    description = "Generic proof assistant";

    longDescription = ''
      Isabelle is a generic proof assistant.  It allows mathematical formulas
      to be expressed in a formal language and provides tools for proving those
      formulas in a logical calculus.
    '';
    homepage = "https://isabelle.in.tum.de/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode # source bundles binary dependencies
    ];
    license = licenses.bsd3;
    maintainers = [
      maintainers.jwiegley
      maintainers.jvanbruegge
    ];
    platforms = platforms.unix;
  };

  passthru.withComponents =
    f:
    let
      isabelle = finalAttrs.finalPackage;
      base = "$out/${isabelle.dirname}";
      components = f isabelle-components;
    in
    symlinkJoin {
      name = "isabelle-with-components-${isabelle.version}";
      paths = [ isabelle ] ++ (map (c: c.override { inherit isabelle; }) components);

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
      ''
      + lib.concatMapStringsSep "\n" (c: ''
        echo contrib/${c.pname}-${c.version} >> ${base}/etc/components
      '') components;
    };
})
