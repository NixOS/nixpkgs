{
  appimageTools,
  fetchurl,
  lib,
  nix-update-script,
  stdenv,
  stdenvNoCC,
}:

let
  pname = "github-copilot-app";
  version = "1.1.2";

  sources = {
    aarch64-darwin = {
      url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-darwin-arm64.tar.gz";
      hash = "sha256-HLCeQbeTO0rF7ZaqZhEv9hcyrqPhnBpgNFbXjGpo68g=";
    };
    aarch64-linux = {
      url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-arm64.AppImage";
      hash = "sha256-6oQmtMcoUL8uhEhvoc14in8xKYS7IB6V8guDZ/vGC8c=";
    };
    x86_64-linux = {
      url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-x64.AppImage";
      hash = "sha256-EKBbXoMGKaUJPA0s39XuxAtrl1CzjctDXHaofDXsiMo=";
    };
  };

  src = fetchurl (
    sources.${stdenv.hostPlatform.system}
      or (throw "github-copilot-app: Unsupported system ${stdenv.hostPlatform.system} system detected.")
  );

  linux = appimageTools.wrapType2 {
    inherit
      meta
      pname
      src
      version
      ;

    extraInstallCommands =
      let
        contents = appimageTools.extractType2 { inherit pname src version; };
      in
      ''
        install -Dm444 "${contents}/usr/share/applications/GitHub Copilot.desktop" $out/share/applications/github-copilot-app.desktop
        substituteInPlace $out/share/applications/github-copilot-app.desktop \
          --replace-fail "Exec=github %u" "Exec=github-copilot-app %u" \
          --replace-fail "Icon=github" "Icon=github-copilot-app"

        for icon in ${contents}/usr/share/icons/hicolor/*/apps/github.png; do
          install -Dm444 "$icon" "$out/share/icons/hicolor/$(basename "$(dirname "$(dirname "$icon")")")/apps/github-copilot-app.png"
        done
      '';

    passthru.updateScript = nix-update-script { };
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      meta
      pname
      src
      version
      ;

    sourceRoot = "GitHub Copilot.app";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/GitHub Copilot.app" "$out/bin"
      cp -R Contents "$out/Applications/GitHub Copilot.app/"
      ln -s "$out/Applications/GitHub Copilot.app/Contents/MacOS/github" \
        "$out/bin/github-copilot-app"

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script { };
  };

  meta = {
    description = "Agent-native desktop experience for GitHub Copilot.";
    homepage = "https://github.com/features/ai/github-app";
    changelog = "https://github.com/github/app/releases/tag/v${version}";
    license = lib.licenses.unfree;
    mainProgram = "github-copilot-app";
    maintainers = with lib.maintainers; [ sheeeng ];
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isLinux then linux else darwin
