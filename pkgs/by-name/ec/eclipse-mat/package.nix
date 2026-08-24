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

    sources = {
      x86_64-linux = {
        suffix = "linux.gtk.x86_64";
        hash = "sha256-4eqAp5hNQR5MTX37qwktqSVfe3ctaBolamEEm8yIN2c=";
      };
      aarch64-linux = {
        suffix = "linux.gtk.aarch64";
        hash = "sha256-MJUome0KjXjmjROTTnDbSTSnDKiUGHt6LAZY1giXmQ0=";
      };
      aarch64-darwin = {
        suffix = "macosx.cocoa.aarch64";
        hash = "sha256-Of/BJTaxD6x0+aNDKeod1RVWG86XFBmk8qdbU/p73qQ=";
      };
    };

    inherit (stdenvNoCC.hostPlatform) system;
    source = sources.${system} or (throw "Unsupported system: ${system}");
  in
  {
    pname = "eclipse-mat";
    version = "1.17.0.20260601";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchurl {
      urls = [
        "https://ftp.halifax.rwth-aachen.de/eclipse/mat/${baseVersion}/rcp/MemoryAnalyzer-${finalAttrs.version}-${source.suffix}.zip"
        "https://download.eclipse.org/mat/${baseVersion}/rcp/MemoryAnalyzer-${finalAttrs.version}-${source.suffix}.zip"
      ];
      inherit (source) hash;
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      makeWrapper
      unzip
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
      copyDesktopItems
      glib
    ];

    buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
      gsettings-desktop-schemas
      gtk3
    ];

    # Keep the .app's notarized upstream signature valid
    dontPatchShebangs = stdenvNoCC.hostPlatform.isDarwin;

    # The bundle ships JNA natives for every OS, so auditTmpdir finds Linux ELF
    # objects and calls patchelf, which does not exist on Darwin.
    noAuditTmpdir = stdenvNoCC.hostPlatform.isDarwin;

    desktopItems = lib.optionals stdenvNoCC.hostPlatform.isLinux [
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

    installPhase =
      if stdenvNoCC.hostPlatform.isDarwin then
        ''
          runHook preInstall

          mkdir -p $out/Applications
          cp -R MemoryAnalyzer.app $out/Applications/

          makeWrapper $out/Applications/MemoryAnalyzer.app/Contents/MacOS/MemoryAnalyzer $out/bin/eclipse-mat \
            --prefix PATH : ${lib.makeBinPath [ jdk ]} \
            --set JAVA_HOME ${jdk.home} \
            --add-flags "-configuration \$HOME/.eclipse-mat/${finalAttrs.version}/configuration"

          runHook postInstall
        ''
      else
        ''
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

    passthru.updateScript = ./update.sh;

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
      maintainers = with lib.maintainers; [
        ktor
        dfjay
      ];
      platforms = lib.attrNames sources;
    };
  }
)
