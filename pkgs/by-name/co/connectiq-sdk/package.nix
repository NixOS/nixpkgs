{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  makeWrapper,
  bashNonInteractive,
  coreutils,
  jre,
  versionCheckHook,
}:

let
  # Build date and commit suffix of the upstream archive name
  build = "2026-06-09-92a1605b2";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "connectiq-sdk";
  version = "9.2.0";

  src = fetchurl {
    url = "https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-${finalAttrs.version}-${build}.zip";
    hash = "sha256-SQfYRVtlHFoAqGXjZMxPGSHAVbknnHyGNMenpnc7VZM=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    bashNonInteractive
    (lib.getLib stdenv.cc.cc)
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # The simulator and monkeymotion GUIs link against webkit2gtk-4.0 and
    # libsoup-2.4, which are no longer available in nixpkgs.
    rm bin/*.bat bin/connectiq bin/simulator bin/monkeymotion
    rm -r share/simulator share/monkeymotion

    mkdir -p $out/share/connectiq-sdk $out/bin
    cp -r . $out/share/connectiq-sdk

    for tool in barrelbuild barreltest era mdd monkeyc monkeydo monkeydoc monkeygraph monkeym; do
      # Some launchers (e.g. monkeym) are shipped without the executable bit
      chmod +x $out/share/connectiq-sdk/bin/$tool
      wrapProgram $out/share/connectiq-sdk/bin/$tool \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            jre
          ]
        }
      ln -s $out/share/connectiq-sdk/bin/$tool $out/bin/$tool
    done

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Garmin Connect IQ SDK for building apps for Garmin wearables";
    longDescription = ''
      Command-line tools of the Garmin Connect IQ SDK, including the Monkey C
      compiler (monkeyc). The SDK root is installed to share/connectiq-sdk.
      Device definitions still have to be downloaded separately via the
      Connect IQ SDK Manager into ~/.Garmin/ConnectIQ/Devices.
    '';
    homepage = "https://developer.garmin.com/connect-iq/sdk/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ sei40kr ];
    mainProgram = "monkeyc";
    platforms = [ "x86_64-linux" ];
  };
})
