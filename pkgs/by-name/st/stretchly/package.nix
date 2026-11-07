{
  stdenv,
  lib,
  fetchurl,
  asar,
  makeWrapper,
  autoPatchelfHook,
  electron,
  makeDesktopItem,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stretchly";
  version = "1.22.1";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      suffix = selectSystem {
        x86_64-linux = "";
        aarch64-linux = "-arm64";
      };
    in
    fetchurl {
      url = "https://github.com/hovancik/stretchly/releases/download/v${finalAttrs.version}/stretchly-${finalAttrs.version}${suffix}.tar.xz";
      hash = selectSystem {
        x86_64-linux = "sha256-Q5Z6os50E5D5aqBK/k5GBlgo3i1HmpOl3atrhvvPGnI=";
        aarch64-linux = "sha256-B3jqQbrjPwZlfIH2Jd8H0tRMT0TDYlfNL6n+ETBDsmg=";
      };
    };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/hovancik/stretchly/v${finalAttrs.version}/stretchly_128x128.png";
    hash = "sha256-tO0cNKopG/recQus7KDUTyGpApvR5/tpmF5C4V14DnI=";
  };

  nativeBuildInputs = [
    asar
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/stretchly/
    asar extract resources/app.asar app
    substituteInPlace app/app/utils/autostartManager.js \
      --replace-fail "new AutoLaunch({ name: 'stretchly' })" \
        "new AutoLaunch({ name: 'stretchly', path: '$out/bin/stretchly' })"
    substituteInPlace app/app/main.js \
      --replace-fail "if (openAtLogin !== currentAutostartValue)" \
        "if (openAtLogin || openAtLogin !== currentAutostartValue)"
    asar pack --unpack '*.node' app $out/share/stretchly/app.asar

    mkdir -p $out/share/applications
    ln -s ${finalAttrs.desktopItem}/share/applications/* $out/share/applications/

    makeWrapper ${electron}/bin/electron $out/bin/stretchly \
      --add-flags $out/share/stretchly/app.asar

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "stretchly";
    exec = "stretchly";
    icon = finalAttrs.icon;
    desktopName = "Stretchly";
    genericName = "Stretchly";
    categories = [ "Utility" ];
  };

  passthru = {
    updateScript = writeScript "update-stretchly" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix curl jq common-updater-scripts
      set -euo pipefail
      latestVersion=$(curl -sL https://api.github.com/repos/hovancik/stretchly/releases/latest | jq -r .tag_name | sed 's/^v//')
      for system in x86_64-linux aarch64-linux; do
        hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url "https://github.com/hovancik/stretchly/releases/download/v$latestVersion/stretchly-$latestVersion$([[ $system == aarch64-linux ]] && echo -arm64).tar.xz"))
        update-source-version stretchly "$latestVersion" "$hash" --system="$system" --ignore-same-version --ignore-same-hash
      done
      update-source-version stretchly "$latestVersion" --source-key=icon --ignore-same-version --ignore-same-hash
    '';
  };

  meta = {
    description = "Break time reminder app";
    longDescription = ''
      stretchly is a cross-platform electron app that reminds you to take
      breaks when working on your computer. By default, it runs in your tray
      and displays a reminder window containing an idea for a microbreak for 20
      seconds every 10 minutes. Every 30 minutes, it displays a window
      containing an idea for a longer 5 minute break.
    '';
    homepage = "https://hovancik.net/stretchly";
    downloadPage = "https://hovancik.net/stretchly/downloads/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "stretchly";
  };
})
