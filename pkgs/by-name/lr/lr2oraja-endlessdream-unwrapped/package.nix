{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  writeShellScriptBin,
  alsa-lib,
  cmake,
  gradle,
  jdk17,
  jportaudio,
  libGL,
}:
let
  jdk = jdk17.override { enableJavaFX = true; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lr2oraja-endlessdream-unwrapped";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "seraxis";
    repo = "lr2oraja-endlessdream";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HphQ8ZzFb21V30fymZZs/BcDQD362jP3PM+HgAAcHKk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gradle
    wrapGAppsHook3
  ];

  # Prevent double wrapping
  dontWrapGApps = true;

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk}"
    "-Dplatform=linux"
  ];

  gradleBuildTask = "shadowJar";

  installPhase = ''
    runHook preInstall

    find dist -type f \
      -name "lr2oraja-*-endlessdream-linux-${finalAttrs.version}.jar" \
      -exec install -Dm555 {} $out/opt/lr2oraja-endlessdream.jar \;

    runHook postInstall
  '';

  postFixup = ''
    makeBinaryWrapper ${jdk}/bin/java $out/bin/lr2oraja-endlessdream \
      --set _JAVA_OPTIONS "-Dsun.java2d.opengl=true \
        -Dawt.useSystemAAFontSettings=on \
        -Dswing.aatext=true \
        -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel \
        -Djdk.gtk.version=2 \
        -Dfile.encoding=UTF-8" \
      --add-flags "-jar $out/opt/lr2oraja-endlessdream.jar" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          alsa-lib
          jportaudio
          libGL
        ]
      }" "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "A featureful fork of beatoraja";
    homepage = "https://github.com/seraxis/lr2oraja-endlessdream";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "lr2oraja-endlessdream";
  };
})
