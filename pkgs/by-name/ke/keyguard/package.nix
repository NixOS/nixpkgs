{
  lib,
  stdenv,
  alsa-lib,
  autoPatchelfHook,
  cargo,
  cmake,
  cups,
  fetchFromGitHub,
  file,
  fontconfig,
  glib,
  gradle_9,
  gtk3,
  jetbrains, # https://github.com/AChep/keyguard-app/commit/e0627190abfd94d9367dec42c39c991d378c3660
  lcms2,
  libglvnd,
  libxinerama,
  libxrandr,
  pkg-config,
  protobuf,
  rustc,
  rustPlatform,
  stripJavaArchivesHook,
  udev,
  writeText,
}:

let
  gradle = gradle_9;

  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "AChep";
    repo = "keyguard-app";
    tag = "r20261127";
    hash = "sha256-08FlSRJv8ewDHOF0ZXGTlxBGpDhlo56UBPRPrOEcAmw=";
  };

  # the helpers are built by gradle, so their crates are vendored
  # (util/crypto has its own lockfile). update.sh refreshes these hashes.
  rootCargoHash = "sha256-isaQJqmn5uVwTWamrxLPmaf7QEPrjYZMuAvr2RbLOWc=";
  cryptoCargoHash = "sha256-Xq8sPC9WL5RfLCTnvfdbr5JmqmBEB0tnal+Mfcpu7VA=";

  rootCargoVendor = rustPlatform.fetchCargoVendor {
    pname = "keyguard-cargo-deps";
    inherit src version;
    hash = rootCargoHash;
  };

  cryptoCargoVendor = rustPlatform.fetchCargoVendor {
    pname = "keyguard-crypto-cargo-deps";
    inherit src version;
    cargoRoot = "util/crypto/rust";
    hash = cryptoCargoHash;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "keyguard";
  inherit version src;

  patches = [
    ./0001-scope-compose-maven-repository.patch
    ./0002-disable-compose-aot.patch
  ];

  postPatch = ''
    # gradle wants 8 GiB
    substituteInPlace gradle.properties \
      --replace-fail 'org.gradle.jvmargs=-Xmx8g' 'org.gradle.jvmargs=-Xmx4g'

    # point cargo at the vendored crates
    mkdir -p .cargo util/crypto/.cargo
    sed "s|@vendor@|${rootCargoVendor}|" \
      ${rootCargoVendor}/.cargo/config.toml > .cargo/config.toml
    sed "s|@vendor@|${cryptoCargoVendor}|" \
      ${cryptoCargoVendor}/.cargo/config.toml > util/crypto/.cargo/config.toml
  '';

  preConfigure = ''
    export ANDROID_USER_HOME="$TMPDIR/.android"
    export CARGO_HOME="$TMPDIR/cargo-home"
    mkdir -p "$ANDROID_USER_HOME" "$CARGO_HOME"
  '';

  gradleBuildTask = ":desktopApp:createReleaseDistributable";

  gradleUpdateTask = finalAttrs.gradleBuildTask;

  # build the helpers offline, as a release build
  gradleFlags = [
    "-Pkeyguard.nativeCargo.cargoOffline=true"
    "-Pbuildkonfig.flavor=release"
  ];

  # default init script breaks compose packaging
  gradleInitScript = writeText "empty-init-script.gradle" "";

  # deps for both linux arches. the hook's nixDownloadDeps is broken on
  # gradle 9, so the task is defined in a scratch init script (no config cache)
  postGradleUpdate = ''
    cat > keyguard-download-deps.gradle <<'EOF'
    gradle.projectsLoaded {
      rootProject.allprojects { p ->
        p.tasks.register("nixDownloadAllDeps") {
          doLast {
            p.configurations.findAll { it.canBeResolved }.each { it.resolve() }
            p.buildscript.configurations.findAll { it.canBeResolved }.each { it.resolve() }
          }
        }
      }
    }
    EOF
    gradle --no-configuration-cache --init-script "$PWD/keyguard-download-deps.gradle" \
      :desktopApp:nixDownloadAllDeps -Dos.family=linux -Dos.arch=amd64 \
      || echo "warning: pre-fetching amd64 dependencies failed" >&2
    gradle --no-configuration-cache --init-script "$PWD/keyguard-download-deps.gradle" \
      :desktopApp:nixDownloadAllDeps -Dos.family=linux -Dos.arch=aarch64 \
      || echo "warning: pre-fetching aarch64 dependencies failed" >&2
  '';

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cargo
    cmake
    gradle
    jetbrains.jdk-no-jcef-21
    pkg-config
    protobuf
    rustc
    stripJavaArchivesHook
  ];

  buildInputs = [
    fontconfig
    libxinerama
    libxrandr
    file
    gtk3
    glib
    cups
    lcms2
    alsa-lib
    libglvnd
    udev
  ];

  # tests are for the whole multiplatform project
  doCheck = false;

  # only used by the crates' build scripts
  dontUseCmakeConfigure = true;

  installPhase = ''
    runHook preInstall

    cp --recursive desktopApp/build/compose/binaries/main-release/app/Keyguard $out

    # fail if Compose changes the app resources path expected below
    grep -Fqx \
      'java-options=-Dcompose.application.resources.dir=$APPDIR/resources' \
      $out/lib/app/Keyguard.cfg

    install -D --mode=0644 $out/lib/Keyguard.png $out/share/icons/hicolor/512x512/apps/keyguard.png

    install -Dm444 -t $out/share/applications/ desktopApp/flatpak/*.desktop
    install -Dm444 desktopApp/flatpak/icon.svg $out/share/icons/hicolor/scalable/apps/com.artemchep.keyguard.svg
    install -Dm444 -t $out/share/metainfo/ desktopApp/flatpak/*.metainfo.xml

    runHook postInstall
  '';

  passthru = {
    # used by update.sh to refresh the hashes above
    inherit rootCargoVendor cryptoCargoVendor;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Third-party client for the Bitwarden platform and KeePass databases";
    homepage = "https://github.com/AChep/keyguard-app";
    changelog = "https://github.com/AChep/keyguard-app/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "Keyguard";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ darkguibrine ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
      binaryNativeCode
    ];
    platforms = lib.platforms.linux;
  };
})
