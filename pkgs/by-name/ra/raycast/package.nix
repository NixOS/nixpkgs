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
  version = "1.89.0";

  src =
    {
      aarch64-darwin = fetchurl {
        name = "Raycast.dmg";
        url = "https://releases.raycast.com/releases/${finalAttrs.version}/download?build=arm";
        hash = "sha256-v/0Sg7f/pf7wt7r0+ewSXGKgBqMFnOwldKQUwKQ8Fz0=";
      };
      x86_64-darwin = fetchurl {
        name = "Raycast.dmg";
        url = "https://releases.raycast.com/releases/${finalAttrs.version}/download?build=x86_64";
        hash = "sha256-UIdoFcnXeCpf1CSBTmdxkP5uKz+WoJt5u5u6MXCqnG4=";
      };
    }
    .${stdenvNoCC.system} or (throw "raycast: ${stdenvNoCC.system} is unsupported.");

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
      x86_url="https://releases.raycast.com/releases/$version/download?build=x86_64"

      arm_hash="sha256-$(curl -sL "$arm_url" | openssl dgst -sha256 -binary | openssl base64)"
      x86_hash="sha256-$(curl -sL "$x86_url" | openssl dgst -sha256 -binary | openssl base64)"

      sed -i -E \
        -e 's|(version = )"[0-9]+\.[0-9]+\.[0-9]+";|\1"'"$version"'";|' \
        -e '/aarch64-darwin = fetchurl/,/};/ s|(hash = )"sha256-[A-Za-z0-9+/]+=";|\1"'"$arm_hash"'";|' \
        -e '/x86_64-darwin = fetchurl/,/};/ s|(hash = )"sha256-[A-Za-z0-9+/]+=";|\1"'"$x86_hash"'";|' \
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
      donteatoreo
      jakecleary
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
