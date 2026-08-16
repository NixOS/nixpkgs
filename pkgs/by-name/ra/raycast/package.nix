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

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "raycast";
  version = "1.104.17";

  src = fetchurl {
    name = "Raycast.dmg";
    url = "https://releases.raycast.com/releases/${finalAttrs.version}/download?build=arm";
    hash = "sha256-muX6PPanjU+ElCQhIfo7Y7cChbTO8Q/gH12ULvBK43s=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Raycast.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Raycast.app
    cp -R . $out/Applications/Raycast.app

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
})
