{
  lib,
  stdenvNoCC,
  fetchurl,
  writeShellApplication,
  cacert,
  curl,
  jq,
  openssl,
  undmg,
}:

stdenvNoCC.mkDerivation {
  pname = "raycast";
  version = "2.0.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    name = "Raycast.dmg";
    url = "https://x-r2.raycast-releases.com/Raycast_2.0.5.0_7ecbc62a97_arm64.dmg";
    hash = "sha256-8/EJVGTfTVqN+4U9vT84TLpo137RWnD2YtFTtYK7tH0=";
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
      jq
      openssl
    ];
    text = ''
      url=$(curl --silent "https://releases.raycast.com/releases/latest?build=universal")
      version=$(echo "$url" | jq -r '.version')

      arm_url="https://releases.raycast.com/releases/$version/download?build=arm"
      arm_hash="sha256-$(curl -sL "$arm_url" | openssl dgst -sha256 -binary | openssl base64)"

      sed -i -E \
        -e 's|(version = )"[0-9]+\.[0-9]+\.[0-9]+";|\1"'"$version"'";|' \
        -e '/src = fetchurl/,/};/ s|(hash = )"sha256-[A-Za-z0-9+/]+=";|\1"'"$arm_hash"'";|' \
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
      jakecleary
    ];
    platforms = [
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
