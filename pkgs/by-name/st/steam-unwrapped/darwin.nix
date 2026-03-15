{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  unzip,
  file,
  xcbuild,
  ...
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "steam-unwrapped";

  bootstrapVersion = "6.1";
  clientVersion = "1773426488";
  expectedArch = if stdenvNoCC.hostPlatform.isAarch64 then "arm64" else "x86_64";
  version = "${finalAttrs.bootstrapVersion}-${finalAttrs.clientVersion}";

  srcFile = "appdmg_osx.zip.984652b88a9737e3f4e77c656d9ffa67d5042c2c";
  src = fetchurl {
    url = "https://client-update.fastly.steamstatic.com/${finalAttrs.srcFile}";
    hash = "sha256-i/TOi0vLxQ9kKYjJVVWfYF56h3NyEW56Kz/RNVAEvts=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;
  dontFixup = true;

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  nativeInstallCheckInputs = [
    file
    xcbuild
  ];
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    unzip -qq "$src"
    tar -xzf SteamMacBootstrapper.tar.gz

    find . -name '._*' -delete

    mkdir -p "$out/Applications"
    cp -R Steam.app "$out/Applications/"

    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/Steam.app/Contents/MacOS/steam_osx" "$out/bin/steam"

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    test -d "$out/Applications/Steam.app"
    test -x "$out/bin/steam"
    test -f "$out/Applications/Steam.app/Contents/MacOS/steam_osx"

    file_output="$(${file}/bin/file "$out/Applications/Steam.app/Contents/MacOS/steam_osx")"
    printf '%s\n' "$file_output" | grep -F "Mach-O"
    printf '%s\n' "$file_output" | grep -F "${finalAttrs.expectedArch}"

    test "$(${xcbuild}/bin/PlistBuddy -c 'Print :CFBundleVersion' "$out/Applications/Steam.app/Contents/Info.plist" | tr -d '"')" = "${finalAttrs.bootstrapVersion}"
    test -z "$(find "$out/Applications/Steam.app" -name '._*' -print -quit)"

    runHook postInstallCheck
  '';

  passthru.updateScript = ./update-darwin.py;

  meta = {
    description = "Digital distribution platform";
    longDescription = ''
      Steam is a video game digital distribution service and storefront from Valve.

      On macOS this package installs Valve's signed Steam bootstrap app, which
      updates itself at runtime outside of the Nix store.
    '';
    homepage = "https://store.steampowered.com/";
    license = lib.licenses.unfreeRedistributable;
    teams = with lib.teams; [ steam ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "steam";
  };
})
