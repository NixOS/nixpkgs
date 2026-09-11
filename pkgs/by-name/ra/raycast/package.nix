{
  lib,
  stdenvNoCC,
  fetchurl,
  writeShellApplication,
  cacert,
  curl,
  openssl,
  undmg,
}:

stdenvNoCC.mkDerivation {
  pname = "raycast";
  version = "2.2.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    name = "Raycast.dmg";
    url = "https://x-r2.raycast-releases.com/Raycast_2.2.0.0_52fdfad707_arm64.dmg";
    hash = "sha256-oxIui7wC2rNV99mU6CWU2PyN2PpaxHbsanQop8+88rI=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Raycast.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Raycast.app"
    cp -R . "$out/Applications/Raycast.app"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/Raycast.app/Contents/MacOS/Raycast" "$out/bin/raycast"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "raycast-update-script";
    runtimeInputs = [
      cacert
      curl
      openssl
    ];
    text = ''
      download_url="https://x.raycast-releases.com/download?platform=macos&architecture=arm64"
      url=$(curl --fail --silent --show-error --head --output /dev/null --write-out '%{redirect_url}' "$download_url")
      filename="''${url##*/}"
      version="''${filename#Raycast_}"
      version="''${version%%_*}"
      hash="sha256-$(curl --fail --silent --show-error --location "$url" | openssl dgst -sha256 -binary | openssl base64)"

      sed -i -E \
        -e 's|(version = )"[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+";|\1"'"$version"'";|' \
        -e 's|url = "https://x-r2\.raycast-releases\.com/Raycast_[^"]*_arm64\.dmg";|url = "'"$url"'";|' \
        -e 's|(hash = )"sha256-[A-Za-z0-9+/]+=";|\1"'"$hash"'";|' \
        ./pkgs/by-name/ra/raycast/package.nix
    '';
  });

  meta = {
    description = "Control your tools with a few keystrokes";
    homepage = "https://raycast.app/";
    license = lib.licenses.unfree;
    mainProgram = "raycast";
    maintainers = with lib.maintainers; [
      lovesegfault
      stepbrobd
      _4evy
    ];
    platforms = [
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
