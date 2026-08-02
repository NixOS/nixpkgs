{
  lib,
  stdenvNoCC,
  bintools,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  unzip,
  jdk,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  libxtst,
  webkitgtk_4_1,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    baseVersion = lib.versions.pad 3 finalAttrs.version;
  in
  {
    pname = "eclipse-mat";
    version = "1.17.0.20260601";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchurl {
      urls = [
        "https://ftp.halifax.rwth-aachen.de/eclipse/mat/${baseVersion}/rcp/MemoryAnalyzer-${finalAttrs.version}-linux.gtk.x86_64.zip"
        "https://download.eclipse.org/mat/${baseVersion}/rcp/MemoryAnalyzer-${finalAttrs.version}-linux.gtk.x86_64.zip"
      ];
      hash = "sha256-4eqAp5hNQR5MTX37qwktqSVfe3ctaBolamEEm8yIN2c=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      copyDesktopItems
      glib
      makeWrapper
      unzip
    ];

    buildInputs = [
      gsettings-desktop-schemas
      gtk3
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "eclipse-mat";
        exec = "eclipse-mat";
        icon = "eclipse-mat";
        comment = "Eclipse Memory Analyzer";
        desktopName = "Eclipse MAT";
        genericName = "Java Memory Analyzer";
        categories = [
          "Development"
          "Profiling"
        ];
      })
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r mat $out/mat

      patchelf --set-interpreter ${bintools.dynamicLinker} $out/mat/MemoryAnalyzer

      # Pass -configuration so that settings are written to ~/.eclipse-mat/<version>
      # instead of the read-only store path.
      makeWrapper $out/mat/MemoryAnalyzer $out/bin/eclipse-mat \
        --prefix PATH : ${lib.makeBinPath [ jdk ]} \
        --set JAVA_HOME ${jdk.home} \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            glib
            gtk3
            libxtst
            webkitgtk_4_1
          ]
        } \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
        --add-flags "-configuration \$HOME/.eclipse-mat/${finalAttrs.version}/configuration"

      unzip -j -q mat/plugins/org.eclipse.mat.ui.rcp_*.jar "icons/memory_analyzer_*.png" -d icons
      for size in 32 48 64 128 256; do
        install -Dm444 icons/memory_analyzer_$size.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/eclipse-mat.png
      done

      runHook postInstall
    '';

    meta = {
      description = "Fast and feature-rich Java heap analyzer";
      longDescription = ''
        The Eclipse Memory Analyzer is a tool that helps you find memory
        leaks and reduce memory consumption. Use the Memory Analyzer to
        analyze productive heap dumps with hundreds of millions of
        objects, quickly calculate the retained sizes of objects, see
        who is preventing the Garbage Collector from collecting objects,
        run a report to automatically extract leak suspects.
      '';
      homepage = "https://eclipse.dev/mat/";
      changelog = "https://eclipse.dev/mat/${baseVersion}/noteworthy.html";
      sourceProvenance = with lib.sourceTypes; [
        binaryBytecode
        binaryNativeCode
      ];
      license = lib.licenses.epl20;
      mainProgram = "eclipse-mat";
      maintainers = [ lib.maintainers.ktor ];
      platforms = [ "x86_64-linux" ];
    };
  }
)
