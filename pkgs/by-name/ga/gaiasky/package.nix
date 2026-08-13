{
  lib,
  stdenv,
  fetchFromCodeberg,
  gradle_9,
  makeBinaryWrapper,
  jdk25,
  jre25_minimal,
  libGL,
  nix-update-script,
  help2man,
}:
let
  jre = jre25_minimal.override {
    # List of dependencies can be obtained using jdeps
    modules = [
      "java.base"
      "java.desktop"
      "java.instrument"
      "java.naming"
      "java.net.http"
      "java.prefs"
      "java.security.jgss"
      "java.sql"
      "jdk.management"
      "jdk.unsupported"
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gaiasky";
  version = "3.7.1";
  src = fetchFromCodeberg {
    owner = "gaiasky";
    repo = "gaiasky";
    tag = finalAttrs.version;
    hash = "sha256-UAVuivkeF234hoUyfCv7depspr3dyoyzYJDD0mKGAr4=";
  };

  nativeBuildInputs = [
    gradle_9
    makeBinaryWrapper
    help2man
    jdk25
  ];

  buildInputs = [
    jre
    libGL
  ];

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "core:dist";

  # Gaiasky binary has to be executed to generate manpage.
  # However, since since /usr/bin/env bash is hardcoded in the binary
  # it errors out. It is generated in postBuild phase instead.
  gradleFlags = [
    "-x :core:generateManPage"
    "-x :core:gzipManPage"
  ];

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # The build output is stored in releases/gaiasky-version-version instead of releases/gaiasky-.
  postPatch = ''
    substituteInPlace build.gradle \
      --replace-fail "def cmd = \"git describe --abbrev=0 --tags HEAD\"" "def cmd = \"echo ${finalAttrs.version}\"" \
      --replace-fail "cmd = \"git rev-parse --short HEAD\"" "cmd = \"echo ${finalAttrs.version}\""
  '';

  postBuild = ''
    patchShebangs --build "releases/gaiasky-${finalAttrs.version}.${finalAttrs.version}"/gaiasky

    # Exclude copyExecutable so that it doesn't overwrite the patched files.
    gradleFlags="" gradle :core:generateManPage -x :core:copyExecutables

    patchShebangs "releases/gaiasky-${finalAttrs.version}.${finalAttrs.version}"/gaiasky
  '';

  installPhase = ''
    runHook preInstall

    install -m755 -d $out/bin $out/share/applications $out/share/metainfo $out/share/gaiasky $out/share/icons/hicolor/scalable/apps $out/share/icons/hicolor/256x256/apps $out/share/man/man6

    cp -r "releases/gaiasky-${finalAttrs.version}.${finalAttrs.version}"/* $out/share/gaiasky/
    ln -s $out/share/gaiasky/gs_icon.svg $out/share/icons/hicolor/scalable/apps/gaiasky.svg
    ln -s $out/share/gaiasky/gs_round_256.png $out/share/icons/hicolor/256x256/apps/gaiasky.png
    ln -s $out/share/gaiasky/space.gaiasky.GaiaSky.metainfo.xml $out/share/metainfo/
    ln -s $out/share/gaiasky/gaiasky.6 $out/share/man/man6/

    substitute $out/share/gaiasky/gaiasky.desktop $out/share/applications/gaiasky.desktop \
      --replace-fail "Icon=/opt/gaiasky/gs_icon.svg" "Icon=gaiasky"

    makeWrapper $out/share/gaiasky/gaiasky \
      $out/bin/gaiasky \
      --set JAVA_HOME ${jre} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source 3D universe visualization software for desktop and VR with support for more than a billion objects";
    homepage = "https://gaiasky.space";
    changelog = "https://codeberg.org/gaiasky/gaiasky/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ reputable2772 ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # MITM Cache
      binaryNativeCode # LWJGL natives are pulled in.
    ];
    platforms = [
      # No aarch64-linux, since upstream does not officially support it.
      "x86_64-linux"
      # Disable darwin due to daemon networking errors
      # "x86_64-darwin"
      # "aarch64-darwin"
    ];
    mainProgram = "gaiasky";
  };
})
