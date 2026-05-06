{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gradle_8,
  jdk17,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gpx-animator";
  version = "1.8.2";

  gradle = gradle_8.override { java = jdk17; };

  nativeBuildInputs = [
    finalAttrs.gradle
    makeBinaryWrapper
  ];

  src = fetchFromGitHub {
    owner = "gpx-animator";
    repo = "gpx-animator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U6nrS7utnUCohCzkOdmehtSdu+5d0KJF81mXWc/666A=";
  };

  mitmCache = finalAttrs.gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # We only need `gradleBuildTask = "shadowJar"` instead of the slower default `gradleBuildTask
  # = "assemble"` (which also generates tarballs, etc) to generate the final .jar. However, the
  # shadowJar task doesn't have dependencies set up correctly so it won't create the
  # `version.txt` file and the resulting application will say "UNKNOWN_VERSION" in the titlebar
  # and everywhere else. As a side effect, we don't need doCheck = true either because the
  # assemble task also runs tests.
  __darwinAllowLocalNetworking = true;

  # Most other java packages use `jre_minimal` with extra modules rather than the full `jdk` as
  # the runtime dependency. But gpx-animator uses javax modules that cannot just be added
  # as modules in jre_minimal.
  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/gpx-animator-${finalAttrs.version}-all.jar -t $out/share/gpx-animator/
    makeWrapper ${jdk17}/bin/java $out/bin/gpx-animator \
      --add-flags "-jar $out/share/gpx-animator/gpx-animator-${finalAttrs.version}-all.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GPX track to video animator";
    longDescription = ''
      GPX Animator generates video from GPX files, it supports:

      - Multiple GPX tracks with mutliple track segments
      - Skipping idle parts
      - Configurable color, label, width and time offset per track
      - Configurable video size, fps and speedup or total video time
      - Background map from any public TMS server
    '';
    homepage = "https://gpx-animator.app";
    changelog = "https://github.com/gpx-animator/gpx-animator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.markasoftware ];
    mainProgram = "gpx-animator";
    platforms = lib.platforms.unix;
  };
})
