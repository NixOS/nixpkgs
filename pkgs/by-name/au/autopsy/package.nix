{
  stdenv,
  lib,
  makeWrapper,
  fetchzip,
  testdisk,
  imagemagick,
  jdk,
  findutils,
  sleuthkit,
  ...
}:
let
  jdkWithJfx = jdk.override (
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      enableJavaFX = true;
    }
  );
in
stdenv.mkDerivation rec {
  pname = "autopsy";
  version = "4.21.0";

  src = fetchzip {
    url = "https://github.com/sleuthkit/autopsy/releases/download/autopsy-${version}/autopsy-${version}.zip";
    hash = "sha256-32iOQA3+ykltCYW/MpqCVxyhh3mm6eYzY+t0smAsWRw=";
  };

  nativeBuildInputs = [
    makeWrapper
    findutils
  ];
  buildInputs = [
    testdisk
    imagemagick
    jdkWithJfx
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    # Run the provided setup script to make files executable and copy sleuthkit
    TSK_JAVA_LIB_PATH="${sleuthkit}/share/java" bash $out/unix_setup.sh -j '${jdkWithJfx}' -n autopsy

    substituteInPlace $out/bin/autopsy \
      --replace-warn 'APPNAME=`basename "$PRG"`' 'APPNAME=autopsy'
    wrapProgram $out/bin/autopsy \
      --run 'export SOLR_LOGS_DIR="$HOME/.autopsy/dev/var/log"' \
      --run 'export SOLR_PID_DIR="$HOME/.autopsy/dev"' \
      --prefix PATH : "${
        lib.makeBinPath [
          testdisk
          imagemagick
          jdkWithJfx
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "Graphical interface to The Sleuth Kit and other open source digital forensics tools";
    homepage = "https://www.sleuthkit.org/autopsy";
    changelog = "https://github.com/sleuthkit/autopsy/releases/tag/autopsy-${version}";
    # Autopsy brings a lot of vendored dependencies
    license = with lib.licenses; [
      asl20
      ipl10
      lgpl3Only
      lgpl21Only
      zlib
      wtfpl
      bsd3
      cc-by-30
      mit
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ zebreus ];
    mainProgram = "autopsy";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    # Autopsy theoretically also supports darwin
    platforms = lib.platforms.x86_64;
  };
}
