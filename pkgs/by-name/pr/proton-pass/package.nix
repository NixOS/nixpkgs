{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  makeWrapper,
  electron,
  asar,
  _7zz,
  writeShellScript,
  common-updater-scripts,
  curl,
  jq,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-pass";
  version = "1.34.2";

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  sourceRoot = if stdenvNoCC.hostPlatform.isDarwin then "." else null;

  # NOTE: -snld prevents "ERROR: Dangerous symbolic link path was ignored"
  # -xr'!*:com.apple.*' prevents macOS extended attributes (e.g. quarantine)
  # being extracted as bogus files that corrupt the .app bundle.
  unpackCmd = lib.optionalString stdenvNoCC.hostPlatform.isDarwin "7zz x -snld -xr'!*:com.apple.*' $curSrc";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs =
    if stdenvNoCC.hostPlatform.isDarwin then
      [
        _7zz
      ]
    else
      [
        dpkg
        makeWrapper
        asar
      ];

  # Rebuild the ASAR archive, hardcoding the resourcesPath
  preInstall = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    asar extract usr/lib/proton-pass/resources/app.asar tmp
    rm usr/lib/proton-pass/resources/app.asar
    substituteInPlace tmp/.webpack/main/index.js \
      --replace-fail "process.resourcesPath" "'$out/share/proton-pass'"
    asar pack tmp/ usr/lib/proton-pass/resources/app.asar
    rm -fr tmp
  '';

  installPhase =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications
        cp -R "./ProtonPass_${finalAttrs.version}/Proton Pass.app" $out/Applications

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/share/proton-pass
        cp -r usr/share/ $out/
        cp -r usr/lib/proton-pass/resources/{app.asar,assets} $out/share/proton-pass/

        runHook postInstall
      '';

  # NOTE: Prevent standard fixup from invalidating the code signature on macOS
  dontFixup = stdenvNoCC.hostPlatform.isDarwin;

  preFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    makeWrapper ${lib.getExe electron} $out/bin/proton-pass \
      --add-flags $out/share/proton-pass/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://proton.me/download/pass/linux/x64/proton-pass_${finalAttrs.version}_amd64.deb";
        hash = "sha256-i5QQ1uzQ2tSDX4I/APL60QcHh9Ovc7ciueRnz7cZUuE=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://proton.me/download/pass/macos/ProtonPass_${finalAttrs.version}.dmg";
        hash = "sha256-oo02IYOKZEsr0+4zimSFkutTGuS63ZvMZTeUTapZrVw=";
      };
      "x86_64-darwin" = finalAttrs.passthru.sources."aarch64-darwin";
    };
    updateScript = writeShellScript "update-proton-pass" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://proton.me/download/PassDesktop/linux/x64/version.json | jq -r '[.Releases[] | select(.CategoryName == "Stable")] | first | .Version')
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "proton-pass" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Desktop application for Proton Pass";
    homepage = "https://proton.me/pass";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      massimogengarelli
      sebtm
      delafthi
    ];
    platforms = builtins.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "proton-pass";
  };
})
