{
  lib,
  stdenv,
  fetchFromGitHub,

  gradle_8,
  jq,
  makeWrapper,
  wrapGAppsHook3,

  libGL,
  libX11,
  fontconfig,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "midis2jam2";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "wyskoj";
    repo = "midis2jam2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/tq/wcmbyjrOP2PLX4vUWwdoG/KLjMkyXuINiuvQjks=";
  };

  patches = [
    # don't embed build time, sort `dependency-licese.json` with jq
    ./make-deterministic.patch

    # otherwise gradle wouldn't cache the deps used by other platforms
    # note: this makes the macos skiko shared library also be present in the jar when building for linux and vica versa
    ./fetch-all-platforms.patch
  ];

  nativeBuildInputs = [
    gradle_8
    jq # used by our patch
    makeWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  mitmCache = gradle_8.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/midis2jam2-current-$version.jar -t $out/share/midis2jam2

    runHook postInstall
  '';

  postFixup =
    let
      extraLibs = [
        libGL
        libX11
        fontconfig
      ];
    in
    ''
      makeWrapper ${lib.getExe jre} $out/bin/midis2jam2 \
        ''${gappsWrapperArgs[@]} \
        ${lib.optionalString stdenv.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath extraLibs}"} \
        --add-flags "-jar $out/share/midis2jam2/midis2jam2-current-$version.jar"
    '';

  meta = {
    changelog = "https://github.com/wyskoj/midis2jam2/releases/tag/${finalAttrs.src.tag}";
    description = "Remaster of MIDIJam, a 3D MIDI file visualizer";
    homepage = "https://github.com/wyskoj/midis2jam2";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "midis2jam2";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode # jar dependencies
      binaryNativeCode # shared libraries inside jar: jnidispatch, lwjgl, skiko
      fromSource
    ];
  };
})
