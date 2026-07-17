{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gradle_8,
  jdk17,
  jogl,
  rsync,
  stripJavaArchivesHook,
  wrapGAppsHook3,
  libGL,
  libxxf86vm,
}:
let
  # Force use of JDK 17, see https://github.com/processing/processing4/issues/1043
  gradle = gradle_8.override { java = jdk17; };
  jdk = jdk17;
  buildNumber = "1310";
in
stdenv.mkDerivation rec {
  pname = "processing";
  version = "4.4.10";

  src = fetchFromGitHub {
    owner = "processing";
    repo = "processing4";
    rev = "processing-${buildNumber}-${version}";
    sha256 = "sha256-u2wQl/VGCNJPd+k3DX2eW7gkA/RARMTSNGcoQuS/Oh8=";
  };

  patches = [
    # Compose Multiplatform generates its createDistributable target too late, and we don't need it anyway
    ./skip-distributable.patch

    # dirPermissions: Without this, some gradle tasks (e.g. includeJdk) fail to copy contents of read-only subfolders within the nix store
    ./fix-permissions.patch

    # Use jogl from nixpkgs instead of downloading from maven
    ./use-nixpkgs-jogl.patch
  ];

  nativeBuildInputs = [
    gradle
    makeWrapper
    stripJavaArchivesHook
    wrapGAppsHook3
  ];
  buildInputs = [
    jdk
    jogl
    rsync
    libGL
    libxxf86vm
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  gradleBuildTask = "createDistributable";
  gradleUpdateTask = "createDistributable";
  enableParallelUpdating = false;

  # Need to run the entire createDistributable task, otherwise the buildPhase fails at the compose checkRuntime step
  gradleUpdateScript = ''
    runHook preBuild
    runHook preGradleUpdate

    gradle createDistributable

    runHook postGradleUpdate
  '';

  dontWrapGApps = true;

  postPatch = ''
    substituteInPlace app/build.gradle.kts \
      --replace-fail "https://github.com/processing/processing-examples/archive/refs/heads/main.zip" "https://github.com/processing/processing-examples/archive/b10c9e9a05a0d6c20d233ca7f30d315b5047720e.zip" \
      --replace-fail "https://github.com/processing/processing-website/archive/refs/heads/main.zip" "https://github.com/processing/processing-website/archive/f11676d1b7464291a23ae834f2ef6ab00baaed8e.zip"

    substituteInPlace core/build.gradle.kts \
      --replace-fail "@@joglPath@@" "${jogl}"
  '';

  buildPhase = ''
    runHook preBuild

    gradle assemble

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    gradle createDistributable

    mkdir -p $out/lib
    cp -dpr app/build/compose/binaries/main/app/Processing/lib/* $out/lib/
    cp -dpr app/build/compose/binaries/main/app/Processing/bin $out/unwrapped

    mkdir -p $out/share/applications/
    cp -dp build/linux/${pname}.desktop $out/share/applications/

    rm -r $out/lib/app/resources/jdk
    ln -s ${jdk}/lib/openjdk $out/lib/app/resources/jdk

    makeWrapper $out/unwrapped/Processing $out/bin/Processing \
      ''${gappsWrapperArgs[@]} \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          libxxf86vm
        ]
      }" \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp"

    runHook postInstall
  '';

  postFixup = ''
    ln -s $out/bin/Processing $out/bin/processing
  '';

  meta = {
    description = "Language and IDE for electronic arts";
    homepage = "https://processing.org";
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
    ];
    mainProgram = "Processing";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ evan-goode ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
}
