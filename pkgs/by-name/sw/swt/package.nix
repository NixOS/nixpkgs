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
  version = "4.33";
  fullVersion = "${finalAttrs.version}-202409030240";

  hardeningDisable = [ "format" ];

  passthru.srcMetadataByPlatform = {
    x86_64-linux.platform = "gtk-linux-x86_64";
    x86_64-linux.hash = "sha256-0OUr+jpwTx5/eoA6Uo2E9/SBAtf+IMMiSVRhOfaWFhE=";
    x86_64-darwin.platform = "cocoa-macosx-x86_64";
    x86_64-darwin.hash = "sha256-n948C/YPF55WPYvub3re/wARLP1Wk+XhJiIuI0YQH5c=";
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
    jdk
    stripJavaArchivesHook
    pkg-config
  ];
  buildInputs = [
    gtk3
    libGLU
  ];

  SWT_JAVA_HOME = jdk;
  AWT_LIB_PATH = "${jdk}/lib/openjdk/lib";
  # Used by the makefile which is responsible for the shared objects only
  OUTPUT_DIR = "${placeholder "out"}/lib";
  # GTK4 is not supported yet. Waiting for:
  # https://github.com/eclipse-platform/eclipse.platform.swt/pull/1482
  makeFlags = "gtk3";
  preBuild = ''
    cd library
    mkdir -p ${finalAttrs.OUTPUT_DIR}
  '';

  # Build the jar
  postBuild = ''
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
