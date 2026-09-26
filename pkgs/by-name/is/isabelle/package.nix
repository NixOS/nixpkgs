{
  lib,
  stdenv,
  fetchurl,
  coreutils,
  net-tools,
  scala_3,
  rlwrap,
  perl,
  procps,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
  isabelleComponents,
  symlinkJoin,
  writableTmpDirAsHomeHook,
}:

let
  platforms = {
    x86_64-linux = "x86_64-linux";
    aarch64-linux = "arm64-linux";
    aarch64-darwin = "arm64-darwin";
  };

  platform = platforms."${stdenv.hostPlatform.system}";

  z3Available = lib.meta.availableOn stdenv.hostPlatform isabelleComponents.z3;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "isabelle";
  version = "2025-2";

  dirname = "Isabelle${finalAttrs.version}";

  src =
    if stdenv.hostPlatform.isDarwin then
      fetchurl {
        url = "https://isabelle.in.tum.de/website-${finalAttrs.dirname}/dist/${finalAttrs.dirname}_macos.tar.gz";
        hash = "sha256-jxh0luKV8WmVLpRHRa+eSuAMnBzS7UytvPfYmOREkT4=";
      }
    else if stdenv.hostPlatform.isx86 then
      fetchurl {
        url = "https://isabelle.in.tum.de/website-${finalAttrs.dirname}/dist/${finalAttrs.dirname}_linux.tar.gz";
        hash = "sha256-ogpQe8fBJw2L6WqfP77AY0U4d4nS3CxNPfYmDUe/szw=";
      }
    else
      fetchurl {
        url = "https://isabelle.in.tum.de/website-${finalAttrs.dirname}/dist/${finalAttrs.dirname}_linux_arm.tar.gz";
        hash = "sha256-ZQqWabSgh2da+zQpTYLe0vBwTUfVgN2e1FzdyfF2S90=";
      };

  nativeBuildInputs = [
    isabelleComponents.jdk
    copyDesktopItems
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    isabelleComponents.polyml
    isabelleComponents.verit
    isabelleComponents.vampire
    isabelleComponents.e
    net-tools
    isabelleComponents.cvc5
    isabelleComponents.csdp
    isabelleComponents.zipperposition
    isabelleComponents.nunchaku
    isabelleComponents.bash_process
  ]
  ++ lib.optionals z3Available [
    isabelleComponents.z3
  ];

  patches = [
    # Make "isabelle build" work when generating documents
    # See: https://github.com/NixOS/nixpkgs/issues/289529
    ./fix-copied-permissions.patch
  ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ procps ];

  sourceRoot = "${finalAttrs.dirname}${lib.optionalString stdenv.hostPlatform.isDarwin ".app"}";

  # The z3 version isabelle uses is only built for x86_64
  # even though it can work on apple-silicon with rosetta, leave this up to the user
  doCheck = z3Available;
  checkPhase = "bin/isabelle build -v HOL-SMT_Examples";

  postUnpack = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv $sourceRoot ${finalAttrs.dirname}
    sourceRoot=${finalAttrs.dirname}
  '';

  postPatch = ''
    patchShebangs lib/Tools/ bin/

    substituteInPlace src/Pure/ML/ml_settings.scala \
      --replace-fail 'polyml_home + Path.basic(ml_platform)' 'Path.explode("${isabelleComponents.polyml}/bin")'

    echo ISABELLE_LINE_EDITOR=${rlwrap}/bin/rlwrap >>etc/settings

    substituteInPlace etc/components \
      --replace-fail 'contrib/bash_process-20240326' '${isabelleComponents.bash_process.settings}' \
      --replace-fail 'contrib/csdp-6.1.1-1' '${isabelleComponents.csdp.settings}' \
      --replace-fail 'contrib/cvc5-1.2.0-1' '${isabelleComponents.cvc5.settings}' \
      --replace-fail 'contrib/e-3.2' '${isabelleComponents.e.settings}' \
      --replace-fail 'contrib/flatlaf-${isabelleComponents.flatlaf.version}' '${isabelleComponents.flatlaf.settings}' \
      --replace-fail 'contrib/jdk-21.0.9' '${isabelleComponents.jdk.settings}' \
      --replace-fail 'contrib/nunchaku-0.5' '${isabelleComponents.nunchaku.settings}' \
      --replace-fail 'contrib/polyml-5.9.2-2' '${isabelleComponents.polyml.settings}' \
      --replace-fail 'contrib/spass-3.8ds-2' '${isabelleComponents.spass.settings}' \
      --replace-fail 'contrib/vampire-4.8' '${isabelleComponents.vampire.settings}' \
      --replace-fail 'contrib/verit-2021.06.2-rmx-3' '${isabelleComponents.verit.settings}' \
      --replace-fail 'contrib/vscode_extension-20251205' "# in vscodium settings" \
      --replace-fail 'contrib/vscodium-${isabelleComponents.vscodium.version}' '${isabelleComponents.vscodium.settings}' \
      --replace-fail 'contrib/zipperposition-2.1-1' '${isabelleComponents.zipperposition.settings}'

    rm -rf contrib/bash_process-20240326 contrib/csdp-6.1.1-1 contrib/cvc5-1.2.0-1 \
           contrib/e-3.2 contrib/flatlaf-3.6.2 contrib/jdk-21.0.9 contrib/nunchaku-0.5 \
           contrib/polyml-5.9.2-2 contrib/spass-3.8ds-2 contrib/vampire-4.8 \
           contrib/verit-2021.06.2-rmx-3 contrib/vscodium-* contrib/z3-4.4.0pre-4 \
           contrib/zipperposition-2.1-1

    substituteInPlace lib/Tools/env \
      --replace-fail /usr/bin/env ${coreutils}/bin/env

    substituteInPlace src/Tools/Setup/src/Environment.java \
      --replace-fail 'cmd.add("/usr/bin/env");' "" \
      --replace-fail 'cmd.add("bash");' "cmd.add(\"$SHELL\");"

    substituteInPlace src/Pure/General/sha1.ML \
      --replace-fail '"$ML_HOME/" ^ (if ML_System.platform_is_windows then "sha1.dll" else "libsha1.so")' '"${isabelleComponents.sha1}/lib/libsha1.so"'

    rm -r heaps
  ''
  + lib.optionalString z3Available ''
    substituteInPlace etc/components \
      --replace-fail 'contrib/z3-${isabelleComponents.z3.version}' '${isabelleComponents.z3.settings}'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    for d in contrib/kodkodi-*/jni/${platform}; do
      patchelf --set-rpath "${
        lib.concatStringsSep ":" [
          "${isabelleComponents.jdk}/lib/openjdk/lib/server"
          "${lib.getLib stdenv.cc.cc}/lib"
        ]
      }" $d/*.so
    done
  '';

  buildPhase = ''
    runHook preBuild

    setup_name=$(basename contrib/isabelle_setup*)

    # Stop Isabelle trying to use `/tmp`.
    user_home="$(bin/isabelle getenv -b ISABELLE_HOME_USER)"
    mkdir -p "$user_home/etc"
    echo 'ISABELLE_TMP_PREFIX="$TMPDIR/isabelle"' > "$user_home/etc/settings"

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
    javac -d "$TARGET_DIR" -classpath "${scala_3.bare}/maven2/org/scala-lang/scala3-interfaces/${scala_3.version}/scala3-interfaces-${scala_3.version}.jar:${scala_3.bare}/maven2/org/scala-lang/scala3-compiler_3/${scala_3.version}/scala3-compiler_3-${scala_3.version}.jar:${isabelleComponents.flatlaf}/share/java/flatlaf-3.6.2-no-natives.jar" "''${ARGS[@]}"
    jar -c -f "$TARGET_DIR/isabelle_setup.jar" -e "isabelle.setup.Setup" -C "$TARGET_DIR" isabelle
    rm -rf "$TARGET_DIR/isabelle"

    bin/isabelle scala_build

    echo "Building HOL heap"
    bin/isabelle build -v -o system_heaps -b HOL

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    mv $TMP/$dirname $out/share
    cd $out/share/$dirname
    bin/isabelle install $out/bin

    # icon
    mkdir -p "$out/share/icons/hicolor/isabelle/apps"
    cp "$out/share/Isabelle${finalAttrs.version}/lib/icons/isabelle.xpm" "$out/share/icons/hicolor/isabelle/apps/"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
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
    })
    (makeDesktopItem {
      name = "isabelle_vscodium";
      exec = "isabelle vscode";
      icon = "isabelle";
      desktopName = "Isabelle (VSCodium)";
      comment = finalAttrs.meta.description;
      categories = [
        "Education"
        "Science"
        "Math"
      ];
    })
  ];

  passthru = {
    inherit platform;
    withComponents =
      f:
      let
        isabelle = finalAttrs.finalPackage;
        base = "$out/${isabelle.dirname}";
        components = f isabelleComponents;
      in
      symlinkJoin {
        name = "isabelle-with-components-${isabelle.version}";
        paths = [ isabelle ];

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
          echo ${c.settings} >> ${base}/etc/components
        '') components;
      };
  };

  meta = {
    description = "Generic proof assistant";
    longDescription = ''
      Isabelle is a generic proof assistant.  It allows mathematical formulas
      to be expressed in a formal language and provides tools for proving those
      formulas in a logical calculus.
    '';
    homepage = "https://isabelle.in.tum.de/";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # source bundles binary dependencies
      binaryBytecode # contains many jars
    ];
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.jvanbruegge
      lib.maintainers.sempiternal-aurora
    ];
    # need to compile the heaps for host on build
    # which requires us to use the host polyml toolchain
    broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
    platforms = lib.attrNames platforms;
  };
})
