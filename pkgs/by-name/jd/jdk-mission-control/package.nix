{
  lib,
  stdenvNoCC,
  bintools,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  common-updater-scripts,
  jq,
  nix-update,
  writeShellApplication,
  unzip,
  jdk,
  atk,
  cairo,
  dconf,
  fontconfig,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  gtk3,
  libsecret,
  pango,
  webkitgtk_4_1,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    sources = {
      x86_64-linux = {
        suffix = "linux.gtk.x86_64";
        hash = "sha256-MIUkS48yu9BkbIEJqfZfcIlJfgfh1rvGL2TalC0n10g=";
      };
      aarch64-linux = {
        suffix = "linux.gtk.aarch64";
        hash = "sha256-MkfA5CA9He4OINXUODOf0j8q29oVLiZGfOo7B4VvxsQ=";
      };
      aarch64-darwin = {
        suffix = "macosx.cocoa.aarch64";
        hash = "sha256-aqv1Ckgc29IV5l+5mA1pq2Dd7J+JcHBhJjn4cUcSoQc=";
      };
    };

    inherit (stdenvNoCC.hostPlatform) system;
    source = sources.${system} or (throw "Unsupported system: ${system}");

    ini =
      if stdenvNoCC.hostPlatform.isDarwin then
        "JDK Mission Control.app/Contents/Eclipse/jmc.ini"
      else
        "JDK Mission Control/jmc.ini";

    launcherArgs = lib.concatStringsSep "\n" [
      "-vm"
      (lib.getExe jdk)
      "-configuration"
      "@user.home/.jmc/${finalAttrs.version}/configuration"
      "-vmargs"
    ];
  in
  {
    pname = "jdk-mission-control";
    version = "9.1.2";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchurl {
      url = "https://github.com/adoptium/jmc-build/releases/download/${finalAttrs.version}/org.openjdk.jmc-${finalAttrs.version}-${source.suffix}.tar.gz";
      inherit (source) hash;
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      makeWrapper
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
      copyDesktopItems
      glib
      unzip
    ];

    buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
      gsettings-desktop-schemas
      gtk3
    ];

    # The bundle ships JNA natives for every OS, so auditTmpdir finds Linux ELF
    # objects and calls patchelf, which does not exist on Darwin.
    noAuditTmpdir = stdenvNoCC.hostPlatform.isDarwin;

    postPatch = ''
      substituteInPlace "${ini}" \
        --replace-fail '-vmargs' ${lib.escapeShellArg launcherArgs}
    '';

    desktopItems = lib.optionals stdenvNoCC.hostPlatform.isLinux [
      (makeDesktopItem {
        name = "jdk-mission-control";
        exec = "jmc open %f";
        icon = "jdk-mission-control";
        comment = "Monitor, profile and troubleshoot Java applications";
        desktopName = "JDK Mission Control";
        genericName = "Java Profiler";
        categories = [
          "Development"
          "Profiling"
        ];
        startupWMClass = "JDK Mission Control";
      })
    ];

    installPhase =
      if stdenvNoCC.hostPlatform.isDarwin then
        ''
          runHook preInstall

          mkdir -p $out/Applications
          cp -R "JDK Mission Control.app" $out/Applications/

          makeWrapper "$out/Applications/JDK Mission Control.app/Contents/MacOS/jmc" \
            $out/bin/jmc

          runHook postInstall
        ''
      else
        ''
          runHook preInstall

          mkdir -p $out
          cp -r "JDK Mission Control" $out/jmc

          patchelf --set-interpreter ${bintools.dynamicLinker} $out/jmc/jmc

          makeWrapper $out/jmc/jmc $out/bin/jmc \
            --prefix LD_LIBRARY_PATH : ${
              lib.makeLibraryPath [
                atk
                cairo
                fontconfig
                glib
                gtk3
                libsecret
                pango
                webkitgtk_4_1
              ]
            } \
            --prefix GIO_EXTRA_MODULES : ${
              lib.makeSearchPath "lib/gio/modules" [
                glib-networking
                (lib.getLib dconf)
              ]
            } \
            --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

          unzip -j -q "JDK Mission Control/plugins/org.openjdk.jmc.rcp.application_"*.jar \
            "icons/mission_control_*.png" -d icons
          for size in 16 32 48 64 128; do
            install -Dm444 icons/mission_control_$size.png \
              $out/share/icons/hicolor/''${size}x''${size}/apps/jdk-mission-control.png
          done

          runHook postInstall
        '';

    passthru = {
      updateScript = lib.getExe (writeShellApplication {
        name = "update-jdk-mission-control";
        runtimeInputs = [
          common-updater-scripts
          jq
          nix-update
        ];
        text = ''
          nix-update jdk-mission-control \
            --url https://github.com/adoptium/jmc-build \
            --version-regex '^([0-9.]+)$'
          version=$(nix eval --raw -f . jdk-mission-control.version)
          if [[ "$version" == "''${UPDATE_NIX_OLD_VERSION-}" ]]; then
            exit 0
          fi
          systems=$(nix eval --json -f . jdk-mission-control.meta.platforms \
            | jq --raw-output '.[]')
          for system in $systems; do
            url=$(nix eval --raw -f . jdk-mission-control.src.url --system "$system")
            hash=$(nix store prefetch-file --json "$url" | jq --raw-output .hash)
            update-source-version \
              jdk-mission-control "$version" "$hash" \
              --system="$system" --ignore-same-version --ignore-same-hash
          done
        '';
      });
    };

    meta = {
      description = "Advanced tool for managing, monitoring, profiling and troubleshooting Java applications";
      longDescription = ''
        JDK Mission Control (JMC) is a set of tools for managing, monitoring,
        profiling and troubleshooting Java applications. It reads and analyses
        Java Flight Recorder (JFR) recordings, enabling detailed analysis of
        code performance, memory and latency without the overhead normally
        associated with profiling tools.

        This package ships the Eclipse Adoptium build of the OpenJDK JMC
        project.
      '';
      homepage = "https://github.com/openjdk/jmc";
      downloadPage = "https://adoptium.net/jmc";
      changelog = "https://github.com/adoptium/jmc-build/releases/tag/${finalAttrs.version}";
      sourceProvenance = with lib.sourceTypes; [
        binaryBytecode
        binaryNativeCode
      ];
      # JMC itself is UPL-1.0; the bundled Eclipse platform is EPL-2.0.
      license = with lib.licenses; [
        upl
        epl20
      ];
      mainProgram = "jmc";
      maintainers = with lib.maintainers; [ dfjay ];
      platforms = lib.attrNames sources;
      identifiers.purlParts = {
        type = "github";
        spec = "adoptium/jmc-build@${finalAttrs.version}";
      };
    };
  }
)
