{
  lib,
  stdenvNoCC,
  buildPackages,
}:

{
  sdkPlatform,
  version,
}:

stdenvNoCC.mkDerivation {
  pname = "${sdkPlatform}-SDK";
  inherit version;

  src = buildPackages.darwin.xcode;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    sdkPath="Contents/Developer/Platforms/${sdkPlatform}.platform/Developer/SDKs/${sdkPlatform}.sdk"

    # Extract the iOS SDK from the nested Xcode.app such that it
    # matches the fetched macOS SDKs
    if [ ! -d "$sdkPath" ]; then
      echo "Error: iOS SDK not found at $sdkPath in Xcode.app"
      echo "Available platforms:"
      ls -la Contents/Developer/Platforms/ || true
      exit 1
    fi

    mkdir -p "$out"
    cp -rd "$sdkPath"/* "$out/"
    rm -rf "$out/usr/bin" "$out/usr/share" 2>/dev/null || true

    runHook postInstall
  '';
}
