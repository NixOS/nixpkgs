{
  fetchzip,
  gtk3,
  jdk,
  lib,
  libGLU,
  pkg-config,
  stdenv,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swt";
  version = "4.34";
  fullVersion = "${finalAttrs.version}-202411201800";

  hardeningDisable = [ "format" ];

  passthru.srcMetadataByPlatform = {
    x86_64-linux.platform = "gtk-linux-x86_64";
    x86_64-linux.hash = "sha256-lKAB2aCI3dZdt3pE7uSvSfxc8vc3oMSTCx5R+71Aqdk=";
    x86_64-darwin.platform = "cocoa-macosx-x86_64";
    x86_64-darwin.hash = "sha256-Uns3fMoetbZAIrL/N0eVd42/3uygXakDdxpaxf5SWDI=";
    aarch64-linux.platform = "gtk-linux-aarch64";
    aarch64-linux.hash = "sha256-lKAB2aCI3dZdt3pE7uSvSfxc8vc3oMSTCx5R+71Aqdk=";
    aarch64-darwin.platform = "cocoa-macosx-aarch64";
    aarch64-darwin.hash = "sha256-G8DOuRuTdFneJSe8ZYdy6WUnFmuUiAyQexxdAOZkYRU=";
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
      inherit (srcMetadata) hash;
      stripRoot = false;
      postFetch =
        # On Darwin, copy the prebuilt swt.jar before processing sources and
        # save it with a different name so it doesn't get removed.
        if stdenv.hostPlatform.isDarwin then
          ''
            cp "$out/swt.jar" "$out/swt-prebuilt.jar" || echo "Warning: swt.jar not found"
            ls -la "$out/"
          ''
        else
          # On Linux, extract and use only the sources from src.zip
          ''
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
    jdk
    stripJavaArchivesHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gtk3
    libGLU
  ];

  SWT_JAVA_HOME = jdk;
  AWT_LIB_PATH = "${jdk}/lib/openjdk/lib";
  # Used by the makefile which is responsible for the shared objects only
  OUTPUT_DIR = "${placeholder "out"}/lib";
  # GTK4 is not supported yet. See:
  # https://github.com/eclipse-platform/eclipse.platform.swt/issues/652
  makeFlags = lib.optionals stdenv.hostPlatform.isLinux [ "gtk3" ];
  preBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
    cd library
    mkdir -p ${finalAttrs.OUTPUT_DIR}
  '';

  # Build the jar (Linux only, Darwin uses prebuilt)
  postBuild = lib.optionalString stdenv.hostPlatform.isLinux ''
    cd ../
    mkdir out
    find org/ -name '*.java' -type f -exec javac -encoding utf8 -d out/ {} +
    # Copy non Java resource files
    find org/ -not -name '*.java' -not -name '*.html' -type f -exec cp {} out/{} \;
  '';

  # The makefile doesn't have an install target, the installation of the shared
  # objects is part of the `all` target.
  installPhase = ''
    runHook preInstall

    install -d -- "$out/jars"

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # On Darwin, use the prebuilt swt.jar which includes native libraries
    # Remove signature files to avoid validation errors after stripJavaArchivesHook modifies the jar
    mkdir -p jar-temp
    cd jar-temp
    ${jdk}/bin/jar -xf ../swt.jar
    rm -f META-INF/*.SF META-INF/*.RSA META-INF/*.DSA
    ${jdk}/bin/jar -cf "$out/jars/swt.jar" *
    cd ..
    rm -rf jar-temp

  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # On Linux, build from source
    install -m 644 -t out -- version.txt

    # Copy native libraries into the jar
    cp -v ${finalAttrs.OUTPUT_DIR}/*.so out/ || true

    (cd out && jar -c *) > "$out/jars/swt.jar"

  ''
  + ''
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.eclipse.org/swt/";
    description = ''
      A widget toolkit for Java to access the user-interface facilities of
      the operating systems on which it is implemented.
    '';
    license = with lib.licenses; [
      # All of these are located in the about_files directory of the source
      ijg
      lgpl21
      mpl11
      mpl20
    ];
    maintainers = [ ];
    platforms = lib.attrNames finalAttrs.passthru.srcMetadataByPlatform;
  };
})
