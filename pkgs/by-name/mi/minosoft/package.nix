{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  gnused,
  jdk17,
  makeBinaryWrapper,
  writeText,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    darwinPlist = writeText "Minosoft-Info.plist" ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>en</string>
        <key>CFBundleExecutable</key>
        <string>Minosoft</string>
        <key>CFBundleIdentifier</key>
        <string>de.bixilon.minosoft</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>Minosoft</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>${finalAttrs.version}</string>
        <key>CFBundleVersion</key>
        <string>${finalAttrs.version}</string>
        <key>NSHighResolutionCapable</key>
        <true/>
      </dict>
      </plist>
    '';
  in
  {
    pname = "minosoft";
    version = "0.1-pre-unstable-2026-05-15";

    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "Bixilon";
      repo = "Minosoft";
      rev = "99ad0edeea786f89829253b4be8a4643b4a5ab1c";
      hash = "sha256-hp4b14v7scNU1GzzKYKAM/3ckH4kVGUJ79n/LokaU4s=";
    };

    nativeBuildInputs = [
      gradle_8
      jdk17
      makeBinaryWrapper
      gnused
    ];

    mitmCache = finalAttrs.passthru.deps;

    gradleFlags = [
      "-Dorg.gradle.java.home=${jdk17}"
      "-Pminosoft.updates=false"
    ];

    # Unit suite only leaves `integrationTest` / `benchmark` to upstream CI due to network.
    gradleCheckTask = "test";

    preCheck = lib.concatMapStringsSep "\n" (
      pat: "gradleFlagsArray+=(--tests ${lib.escapeShellArg pat})"
    ) [ ];

    # Upstream picks LWJGL/JavaFX/zstd natives from Gradle project properties `platform` / `architecture`
    preConfigure = ''
      chmod u+w gradle.properties

      printf '\n# nixpkgs: reproducible native artifact tuple\nplatform=%s\narchitecture=%s\n' \
      '${if stdenv.hostPlatform.isLinux then "LINUX" else "MAC"}' \
      '${if stdenv.hostPlatform.isx86_64 then "amd64" else "aarch64"}' \
      >> gradle.properties
    '';

    gradleBuildTask = "fatJar";

    # Leave the jars alone
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin"
      jar="$(echo build/libs/minosoft-fat-*.jar)"
      if ! [ -f "$jar" ]; then
        echo "Expected fat jar under build/libs/, got: $jar" >&2
        ls -la build/libs || true
        exit 1
      fi
    ''
    + (
      if stdenv.hostPlatform.isDarwin then
        ''
          app="$out"/Applications/Minosoft.app
          mkdir -p "$app"/Contents/MacOS
          jarOut="$app"/Contents/MacOS/minosoft-fat.jar
          install -Dm644 "$jar" "$jarOut"

          makeWrapper ${lib.getExe jdk17} "$app"/Contents/MacOS/Minosoft \
            --set JAVA_HOME "${jdk17.home}" \
            --add-flags "-jar $jarOut"

          install -Dm644 ${darwinPlist} "$app"/Contents/Info.plist

          ln -sf "$app"/Contents/MacOS/Minosoft "$out/bin/minosoft"
        ''
      else
        ''
          mkdir -p "$out/share/minosoft"
          jarOut="$out/share/minosoft/minosoft-fat.jar"
          install -Dm644 "$jar" "$jarOut"

          makeWrapper ${lib.getExe jdk17} "$out/bin/minosoft" \
            --add-flags "-jar $jarOut"
        ''
    )
    + ''
      runHook postInstall
    '';

    passthru = {
      deps = gradle_8.fetchDeps {
        pname = "minosoft";
        data = ./deps.json;
      };

      updateScript = finalAttrs.passthru.deps.updateScript;
    };

    meta = {
      changelog = "https://github.com/Bixilon/Minosoft/commits/master/";
      description = "Open-source Minecraft client focused on protocol features";
      homepage = "https://github.com/Bixilon/Minosoft";
      license = lib.licenses.gpl3Plus;
      sourceProvenance = with lib.sourceTypes; [
        fromSource
        binaryBytecode # Gradle dependency jars
      ];
      longDescription = ''
        Minosoft is an unofficial Minecraft client implemented in Kotlin on the JVM with OpenGL (via LWJGL).
        It implements protocol-level Minecraft networking and related tooling.

        Externally download Microsoft  assets and some authentication mechanisms may be subject to terms beyond GPLv3;
        only Minosoft’s own
        source and this build recipe are guaranteed free under the declared license.
      '';
      maintainers = with lib.maintainers; [ philocalyst ];
      platforms = lib.platforms.unix;
      mainProgram = "minosoft";
    };
  }
)
