{
  lib,
  stdenv,
  symlinkJoin,
  maven,
  makeDesktopItem,
  fetchFromGitHub,
  jdk25,
  jre25_minimal,
  openjfx25,
  xmlstarlet,
  glib,
  libxxf86vm,
  libxtst,
  libx11,
  gtk3,
  libGL,

  # native
  copyDesktopItems,
  wrapGAppsHook3,
  gettext,
}:

let
  # The JavaFX modules pdfsam-basic jlinks in, and the plain JDK modules it
  # adds alongside them (taken from pdfsam-basic/pom.xml's jlink execution).
  javafxModules = [
    "javafx.base"
    "javafx.graphics"
    "javafx.controls"
    "javafx.media"
  ];
  jdkModules = [
    "java.base"
    "java.logging"
    "java.naming"
    "java.sql"
    "java.desktop"
    "java.xml"
    "java.management"
    "jdk.unsupported"
    "java.prefs"
    "jdk.localedata"
  ];

  # Upstream builds their linux-x64 tarball with BellSoft's Liberica
  # "jdk+fx" distribution, whose jmods directory bundles JavaFX modules.
  # nixpkgs' openjfx doesn't provide prebuilt jmods (only exploded module
  # classes without a compiled module-info.class), so we build our own
  # jmods for the JavaFX modules pdfsam-basic needs, compiling openjfx's
  # own module-info.java sources against its classes and bundling in the
  # native libraries and legal notices. Laid out under lib/openjdk/jmods
  # like jdk25 itself, so it can be merged with it below.
  javafxJmods = stdenv.mkDerivation {
    pname = "openjfx-jmods";
    inherit (openjfx25) version;

    dontUnpack = true;
    nativeBuildInputs = [ jdk25 ];

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/lib/openjdk/jmods
      staging=$TMPDIR/staging
    ''
    + lib.pipe javafxModules [
      (map (mod: ''
        mkdir -p "$staging/${mod}"
        cp -r ${openjfx25}/modules/${mod}/. "$staging/${mod}/"
        javac \
          --module-path "$staging" \
          -d "$staging/${mod}" \
          ${openjfx25}/modules_src/${mod}/module-info.java
        jmodArgs=(--class-path "$staging/${mod}")
        if [ -d "${openjfx25}/modules_libs/${mod}" ]; then
          jmodArgs+=(--libs "${openjfx25}/modules_libs/${mod}")
        fi
        if [ -d "${openjfx25}/modules_legal/${mod}" ]; then
          jmodArgs+=(--legal-notices "${openjfx25}/modules_legal/${mod}")
        fi
        jmod create "''${jmodArgs[@]}" "$out/lib/openjdk/jmods/${mod}.jmod"
      ''))
      (lib.concatStringsSep "\n")
    ]
    + ''
      runHook postBuild
    '';

    dontInstall = true;
  };

  # jdk25 with javafxJmods' jmods merged into the same lib/openjdk/jmods
  # directory, so it can be dropped straight into jre_minimal's `jdk`
  # argument below (jre.nix jlinks from `${jdk}/lib/openjdk/jmods` alone).
  jdk25WithJavafx = symlinkJoin {
    inherit (jdk25) pname version;
    paths = [
      jdk25
      javafxJmods
    ];
  };

  # A minimal JRE, containing exactly the modules pdfsam-basic uses
  # (JavaFX included), so we don't need a full external JDK/JRE just to
  # run the app.
  jre = jre25_minimal.override {
    jdk = jdk25WithJavafx;
    modules = jdkModules ++ javafxModules;
  };
in
maven.buildMavenPackage rec {
  pname = "pdfsam-basic";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "torakiki";
    repo = "pdfsam";
    tag = "v${version}";
    hash = "sha256-RbCZ7HQvb2FN5JxsdZvjFeMTt/N2qJE9iK7vGezSuD8=";
  };

  mvnParameters = "-Drelease -Dmaven.test.skip";
  mvnHash = "sha256-l8ns++RTK69AV2dq8EFPOzhfzhcgYQlF/OUZ0IZ7QII=";

  # fix for:
  #
  #   date 1980-01-01T00:00:00Z is not within the valid range 1980-01-01T00:00:02Z to 2099-12-31T23:59:59Z
  env.SOURCE_DATE_EPOCH = 315532802; # 1980-01-01T00:00:02Z
  mvnFetchExtraArgs.env = {
    inherit (env) SOURCE_DATE_EPOCH;
  };

  # pdfsam-parent's pom.xml only activates the maven-toolchains-plugin (which
  # would require a toolchains.xml we don't provide) when the JDK running
  # Maven is older than 25. Running Maven itself with a JDK 25 avoids that,
  # and is also required since the project now compiles with
  # `-release 25`. We use nixpkgs' own from-source jdk25 rather than
  # temurin-bin-25: the latter ships without a jmods directory, and its
  # jlink relies on a JDK 25 "self-hosting" feature (building a runtime
  # image directly off the currently running JDK's own linked image)
  # that SHA-512-checksums resource files like man pages against their
  # expected path, which fails since nixpkgs relocates them to
  # $out/share/man instead of $out/man.
  mvnJdk = jdk25;

  # Point pdfsam-basic's own jlink invocation (which upstream assumes runs
  # with a JDK that bundles JavaFX as jmods) at the merged jmods dir above.
  postPatch = ''
    xmlstarlet ed --inplace -N x=http://maven.apache.org/POM/4.0.0 \
      -i '//x:argument[text()="--add-modules"]' -t elem -n argument -v '--module-path' \
      -i '//x:argument[text()="--add-modules"]' -t elem -n argument -v '${jdk25WithJavafx}/lib/openjdk/jmods' \
      pdfsam-basic/pom.xml
  '';

  buildInputs = [
    glib
    libxxf86vm
  ];

  nativeBuildInputs = [
    # Used as the main java implementation. Also the build relies upon jlink
    # which is included in this package.
    jdk25
    xmlstarlet
    gettext
    wrapGAppsHook3
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    install -Dm0644 pdfsam-basic/src/deb/icon.svg $out/share/icons/pdfsam-basic.svg
    mkdir $out/lib
    tar -xf pdfsam-basic/target/pdfsam-basic-${version}-linux-x64.tar.gz -C $out/lib
    mv $out/lib/pdfsam-basic-${version}-linux-x64 $out/lib/pdfsam-basic
    # Based upon upstream's default $out/lib/pdfsam-basic/bin/pdfsam.sh file,
    # but with Nix specific dynamically loaded libraries
    makeWrapper ${jre}/bin/java $out/bin/pdfsam-basic \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxxf86vm
          libxtst
          libx11
          gtk3
          libGL
        ]
      }" \
      --argv0 pdfsam-basic \
      --add-flags --enable-preview \
      --add-flags "--module-path $out/lib/pdfsam-basic/lib" \
      --add-flags "--module org.pdfsam.basic/org.pdfsam.basic.App" \
      --add-flags "-Xmx512M" \
      --add-flags "-Dprism.lcdtext=false" \
      --add-flags "-splash:$out/lib/pdfsam-basic/splash.png" \
      --add-flags "-Dapp.name=pdfsam-basic" \
      --add-flags "-Dapp.home=$out/lib/pdfsam-basic" \
      --add-flags "-Dbasedir=$out/lib/pdfsam-basic"
    # Remove bundled executables, shared objects etc, that are not needed on
    # Nix (we just need the jar files).
    rm -r $out/lib/pdfsam-basic/{doc,bin,runtime}

    runHook postInstall
  '';

  # Based on upstream's desktop file:
  # https://github.com/torakiki/pdfsam/blob/master/pdfsam-basic/src/deb/pdfsam-basic.desktop
  desktopItems = [
    (makeDesktopItem {
      name = "PDFsam Basic";
      exec = "pdfsam-basic";
      icon = "pdfsam-basic";
      comment = meta.description;
      desktopName = "PDFsam Basic";
      genericName = "PDF Split and Merge";
      mimeTypes = [ "application/pdf" ];
      categories = [ "Office" ];
    })
  ];

  meta = {
    homepage = "https://github.com/torakiki/pdfsam";
    description = "Multi-platform software designed to extract pages, split, merge, mix and rotate PDF files";
    mainProgram = "pdfsam-basic";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      doronbehar
      _1000101
    ];
  };
}
