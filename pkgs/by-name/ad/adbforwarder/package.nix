{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  dotnet-runtime,
  autoPatchelfHook,
  zlib,
  icu,
  openssl,
  android-tools,
}:

stdenv.mkDerivation rec {
  pname = "adbforwarder";
  version = "1.4";

  src = fetchzip {
    url = "https://github.com/alvr-org/ADBForwarder/releases/download/v${version}/ADBForwarder-linux-x64.zip";
    hash = "sha256-ECyaeFJbFceTDvKJLvdHC+ZJpugUN5k4p5IQbiNeZrk=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    dotnet-runtime
    zlib
    icu
    openssl
    android-tools
  ];

  propagatedBuildInputs = [
    icu
    android-tools
  ];

  autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}
    cp -r ./* $out/share/${pname}/
    chmod +x $out/share/${pname}/ADBForwarder

    # Create the platform-tools directory that the app expects
    mkdir -p $out/share/${pname}/adb/platform-tools

    # Link the system adb into the expected location
    ln -sf ${android-tools}/bin/adb $out/share/${pname}/adb/platform-tools/adb

    # Create a wrapper script in $out/bin which will be in PATH
    makeWrapper $out/share/${pname}/ADBForwarder $out/bin/adbforwarder \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Handle ADB connections to Android VR headsets for ALVR";
    homepage = "https://github.com/alvr-org/ADBForwarder";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ deathraymind ];
  };
}
