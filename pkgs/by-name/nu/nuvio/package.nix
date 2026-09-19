{
  alsa-lib,
  autoPatchelfHook,
  cmake,
  copyDesktopItems,
  fetchFromGitHub,
  file,
  fontconfig,
  glib,
  glib-networking,
  gradle_9,
  gst_all_1,
  gtk3,
  lib,
  libx11,
  libxcomposite,
  libxext,
  libxtst,
  makeDesktopItem,
  mpv-unwrapped,
  nix-update-script,
  pkg-config,
  stdenv,
  temurin-bin-17,
  webkitgtk_4_1,
  wrapGAppsHook3,
  writeText,
}:
let
  # Listed once, used three times: buildInputs, LD_LIBRARY_PATH, GST plugin path.
  runtimeLibs = [
    mpv-unwrapped
    webkitgtk_4_1
    gtk3
    glib
    glib-networking
    fontconfig
    libx11
    libxcomposite
    libxext
    libxtst
    alsa-lib
  ];
  gstPlugins = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nuvio";
  version = "0.1.23-alpha";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NuvioMedia";
    repo = "NuvioDesktop";
    tag = finalAttrs.version;
    hash = "sha256-dCzSotVSLQjspIodpbdZAcUuCZLmcVU4T+Sgbtt0NMA=";
  };

  patches = [ ./disable-android-target.patch ];

  gradleBuildTask = ":composeApp:createReleaseDistributable";

  gradleUpdateTask = finalAttrs.gradleBuildTask;

  gradleInitScript = writeText "empty-init-script.gradle" "";

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  env.JAVA_HOME = temurin-bin-17;

  gradleFlags = [ "-Dorg.gradle.java.home=${temurin-bin-17}" ];

  nativeBuildInputs = [
    gradle_9
    temurin-bin-17
    pkg-config
    cmake
    # for the vendored player's cmake build
    gst_all_1.gstreamer.dev
    gst_all_1.gst-plugins-base.dev
    copyDesktopItems
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    # player_bridge.cpp headers (matches its pkg-config line)
    mpv-unwrapped.dev
    webkitgtk_4_1.dev
    gtk3.dev
    libx11.dev
    libxcomposite.dev
    libxext.dev
    file
  ]
  ++ runtimeLibs
  ++ gstPlugins;

  # Upstream tests need a display server / Android emulator; nothing runnable headless.
  doCheck = false;

  # Upstream's public Supabase identifiers (URL + anon key are public by
  # design and ship in every official release; extracted from the official
  # .deb (0.1.22-alpha, same upstream Supabase project). Baked in so account
  # sign-in/sync works like official builds.
  postPatch = ''
    cat > local.properties <<'EOF'
    NUVIO_SUPABASE_URL=https://api.nuvio.tv
    NUVIO_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzgxNTIxMzQ2LCJleHAiOjE5MzkyMDEzNDZ9.tmQaj682pwzehpqlgCDMnySOqiUvpgRbrE43T4VJpDI
    NUVIO_SUPABASE_FALLBACK_URL=https://api-two.nuvioapp.space
    EOF
  '';

  # Gradle build, but the cmake binary is needed for the player's build.sh:
  # keep the cmake hook out of configurePhase.
  dontUseCmakeConfigure = true;

  desktopItems = [
    (makeDesktopItem {
      name = "nuvio";
      exec = "nuvio";
      icon = "nuvio";
      desktopName = "Nuvio";
      comment = finalAttrs.meta.description;
      categories = [ "AudioVideo" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    cp --recursive composeApp/build/compose/binaries/main-release/app/Nuvio $out

    mkdir -p $out/share/icons/hicolor/512x512/apps
    ln -s $out/bin/Nuvio $out/bin/nuvio
    install -D --mode=0644 $out/lib/Nuvio.png $out/share/icons/hicolor/512x512/apps/nuvio.png
    # The wrapper renames the launcher to .Nuvio-wrapped, and the jpackage
    # launcher derives its .cfg name from its own file name — link it back.
    ln -s $out/lib/app/Nuvio.cfg $out/lib/app/.Nuvio-wrapped.cfg

    runHook postInstall
  '';

  # Player libraries unpack from jars at runtime, so only the wrapper env reaches them.
  # Host NVIDIA libs for NVDEC come via /run/opengl-driver/lib (katago/zenith).
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}:/run/opengl-driver/lib"
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${lib.makeSearchPath "lib/gstreamer-1.0" gstPlugins}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source media client for browsing metadata and playing user-provided streams";
    homepage = "https://github.com/NuvioMedia/NuvioDesktop";
    changelog = "https://github.com/NuvioMedia/NuvioDesktop/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ subham-roy ];
    mainProgram = "nuvio";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
