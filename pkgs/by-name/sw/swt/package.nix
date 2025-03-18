{
  atk,
  fetchzip,
  gtk2,
  jdk,
  lib,
  libGL,
  libGLU,
  libXt,
  libXtst,
  pkg-config,
  stdenv,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swt";
  version = "4.5";
  fullVersion = "${finalAttrs.version}-201506032000";

  hardeningDisable = [ "format" ];

  passthru.srcMetadataByPlatform = {
    x86_64-linux.platform = "gtk-linux-x86_64";
    x86_64-linux.sha256 = "17frac2nsx22hfa72264as31rn35hfh9gfgy0n6wvc3knl5d2716";
    i686-linux.platform = "gtk-linux-x86";
    i686-linux.sha256 = "13ca17rga9yvdshqvh0sfzarmdcl4wv4pid0ls7v35v4844zbc8b";
    x86_64-darwin.platform = "cocoa-macosx-x86_64";
    x86_64-darwin.sha256 = "0wjyxlw7i9zd2m8syd6k1q85fj8pzhxlfsrl8fpgsj37p698bd0a";
  };
  passthru.srcMetadata =
    finalAttrs.passthru.srcMetadataByPlatform.${stdenv.hostPlatform.system} or null;
  # Alas, the Eclipse Project apparently doesn't produce source-only
  # releases of SWT.  So we just grab a binary release and extract
  # "src.zip" from that.
  src =
    let
      inherit (finalAttrs.passthru) srcMetadata;
    in
    assert srcMetadata != null;
    fetchzip {
      url = "https://archive.eclipse.org/eclipse/downloads/drops4/R-${finalAttrs.fullVersion}/swt-${finalAttrs.version}-${srcMetadata.platform}.zip";
      inherit (srcMetadata) sha256;
      stripRoot = false;
      postFetch = ''
        mkdir "$unpackDir"
        cd "$unpackDir"

        renamed="$TMPDIR/src.zip"
        mv -- "$out/src.zip" "$renamed"
        unpackFile "$renamed"
        rm -r -- "$out"

        mv -- "$unpackDir" "$out"
      '';
    };

  nativeBuildInputs = [
    stripJavaArchivesHook
    pkg-config
  ];
  buildInputs = [
    atk
    gtk2
    jdk
    libGL
    libGLU
    libXtst
  ] ++ lib.optionals (lib.hasPrefix "8u" jdk.version) [ libXt ];

  patches = [
    ./awt-libs.patch
    ./gtk-libs.patch
  ];

  prePatch = ''
    # clear whitespace from makefiles (since we match on EOL later)
    sed -i 's/ \+$//' ./*.mak
  '';

  postPatch =
    let
      makefile-sed = builtins.toFile "swt-makefile.sed" ''
        # fix pkg-config invocations in CFLAGS/LIBS pairs.
        #
        # change:
        #     FOOCFLAGS = `pkg-config --cflags `foo bar`
        #     FOOLIBS = `pkg-config --libs-only-L foo` -lbaz
        # into:
        #     FOOCFLAGS = `pkg-config --cflags foo bar`
        #     FOOLIBS = `pkg-config --libs foo bar`
        #
        # the latter works more consistently.
        /^[A-Z0-9_]\+CFLAGS = `pkg-config --cflags [^`]\+`$/ {
          N
          s/${''
            ^\([A-Z0-9_]\+\)CFLAGS = `pkg-config --cflags \(.\+\)`\
            \1LIBS = `pkg-config --libs-only-L .\+$''}/${''
            \1CFLAGS = `pkg-config --cflags \2`\
            \1LIBS = `pkg-config --libs \2`''}/
        }
        # fix WebKit libs not being there
        s/\$(WEBKIT_LIB) \$(WEBKIT_OBJECTS)$/\0 `pkg-config --libs glib-2.0`/g
      '';
    in
    ''
      declare -a makefiles=(./*.mak)
      sed -i -f ${makefile-sed} "''${makefiles[@]}"
      # assign Makefile variables eagerly & change backticks to `$(shell …)`
      sed -i -e 's/ = `\([^`]\+\)`/ := $(shell \1)/' \
        -e 's/`\([^`]\+\)`/$(shell \1)/' \
        "''${makefiles[@]}"
    '';

  buildPhase = ''
    runHook preBuild

    export JAVA_HOME=${jdk}

    ./build.sh

    mkdir out
    find org/ -name '*.java' -type f -exec javac -d out/ {} +

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    if [[ -n "$prefix" ]]; then
      install -d -- "$prefix"
    fi

    install -Dm 644 -t "$out/lib" -- *.so

    install -d -- "$out/jars"
    install -m 644 -t out -- version.txt
    (cd out && jar -c *) > "$out/jars/swt.jar"

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.eclipse.org/swt/";
    description = ''
      A widget toolkit for Java to access the user-interface facilities of
      the operating systems on which it is implemented.
    '';
    license = lib.licenses.epl10;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
