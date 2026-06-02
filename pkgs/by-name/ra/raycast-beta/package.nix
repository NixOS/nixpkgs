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

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "raycast-beta";
  version = "0.60.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src =
    {
      aarch64-darwin = fetchurl {
        name = "Raycast_Beta.dmg";
        url = "https://x-r2.raycast-releases.com/Raycast_Beta_${finalAttrs.version}_2fc04147cc_arm64.dmg";
        hash = "sha256-PQX5l5UzlphKySIR5QRcJvJLe9NxQrTOPLy3itV0QHU=";
      };
    }
    .${stdenvNoCC.system} or (throw "raycast-beta: ${stdenvNoCC.system} is unsupported.");

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Raycast Beta.app";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Raycast Beta.app"
    cp -R . "$out/Applications/Raycast Beta.app"
    mkdir -p "$out/bin"
    ln -s "$out/Applications/Raycast Beta.app/Contents/MacOS/Raycast Beta" "$out/bin/raycast-beta"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "raycast-beta-update-script";
    runtimeInputs = [
      cacert
      curl
      openssl
    ];
    text = ''
      url=$(curl --silent "https://www.raycast.com/new" | grep -o 'https://x-r2\.raycast-releases\.com/Raycast_Beta_[^"]*_arm64\.dmg' | head -n1)
      version=$(echo "$url" | sed -E 's|.*/Raycast_Beta_([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)_[^/]+_arm64\.dmg|\1|')
      hash="sha256-$(curl -sL "$url" | openssl dgst -sha256 -binary | openssl base64)"

      sed -i -E \
        -e 's|(version = )"[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+";|\1"'"$version"'";|' \
        -e 's|url = "https://x-r2\.raycast-releases\.com/Raycast_Beta_[^"]*_arm64\.dmg";|url = "'"$url"'";|' \
        -e 's|(hash = )"sha256-[A-Za-z0-9+/]+=";|\1"'"$hash"'";|' \
        ./pkgs/by-name/ra/raycast-beta/package.nix
    '';
  });

  meta = {
    description = "Control your tools with a few keystrokes - beta release";
    homepage = "https://raycast.app/";
    license = lib.licenses.unfree;
    mainProgram = "raycast-beta";
    maintainers = with lib.maintainers; [ FlameFlag ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
