{
  lib,
  maven,
  makeDesktopItem,
  fetchFromGitHub,
  temurin-jre-bin-21,
  temurin-bin-21,
  glib,
  libxxf86vm,
  libxtst,
  gtk3,
  libGL,

  # native
  copyDesktopItems,
  wrapGAppsHook3,
  gettext,
}:

let
  mavenOurJdk = maven.override {
    jdk_headless = temurin-jre-bin-21;
  };
in
mavenOurJdk.buildMavenPackage rec {
  pname = "pdfsam-basic";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "torakiki";
    repo = "pdfsam";
    rev = "v${version}";
    hash = "sha256-9IzYnWYE0OD1b4xybl3NdaBvVSw6C4+1ORUnrotqSuc=";
  };

  mvnParameters = "-Drelease -Dmaven.test.skip";
  mvnHash = "sha256-Y/wz/XuzDpT7qnk/pRBkv6PeI0GmqKXh54gqb7cWHHw=";

  buildInputs = [
    glib
    libxxf86vm
  ];

  nativeBuildInputs = [
    # Used as the main java implementation. Also the build relies upon jlink
    # which is included in this package.
    temurin-bin-21
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
    makeWrapper ${temurin-jre-bin-21}/bin/java $out/bin/pdfsam-basic \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxxf86vm
          libxtst
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
