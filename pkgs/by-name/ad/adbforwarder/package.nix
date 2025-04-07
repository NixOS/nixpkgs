{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  dotnet-runtime,
  autoPatchelfHook,
  zlib,
  gcc-unwrapped,
  lttng-ust,
  icu,
  openssl,
  android-tools,
}:

stdenv.mkDerivation rec {
  pname = "adbforwarder";
  version = "1.4";

  src = fetchzip {
    url = "https://github.com/alvr-org/ADBForwarder/releases/download/v${version}/ADBForwarder-linux-x64.zip";
    sha256 = "sha256-ECyaeFJbFceTDvKJLvdHC+ZJpugUN5k4p5IQbiNeZrk=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    dotnet-runtime
    zlib
    gcc-unwrapped
    lttng-ust
    icu
    openssl
    android-tools
  ];

  propagatedBuildInputs = [
    icu
    android-tools
  ];

  # Instruct autoPatchelfHook to ignore missing liblttng-ust.so.0.
  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}
    cp -r source/* $out/share/${pname}/
    chmod +x $out/share/${pname}/ADBForwarder

    # Create the platform-tools directory that the app expects
    mkdir -p $out/share/${pname}/adb/platform-tools

    # Link the system adb into the expected location
    ln -sf ${android-tools}/bin/adb $out/share/${pname}/adb/platform-tools/adb

    # Create a wrapper script in $out/bin which will be in PATH
    makeWrapper $out/share/${pname}/ADBForwarder $out/bin/adbforwarder \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --prefix PATH : ${lib.makeBinPath [ android-tools ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "ADB Forwarder for ALVR (Air Light VR)";
    longDescription = ''
      ADB Forwarder is a tool for ALVR that handles ADB connections to Android
      VR headsets.
    '';
    homepage = "https://github.com/alvr-org/ADBForwarder";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ deathraymind ];
  };
}
