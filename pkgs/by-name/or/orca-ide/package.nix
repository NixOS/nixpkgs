{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  desktop-file-utils,
  nix-update-script,
  makeWrapper,
  unzip,
  git,
  libnotify,
  openssh,
}:

let
  pname = "orca-ide";
  version = "1.4.188";

  sources = {
    x86_64-linux = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
      hash = "sha256-LnDLXhmXQeVgKnBgglV1MZ9eA7wvqkuJzScyjz9V1LQ=";
    };
    aarch64-linux = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux-arm64.AppImage";
      hash = "sha256-7bls9o5MXZRCuRPoLK1bbCOmOZ+DmOj0eYlVu7nJSRg=";
    };
    aarch64-darwin = {
      url = "https://github.com/stablyai/orca/releases/download/v${version}/Orca-${version}-arm64-mac.zip";
      hash = "sha256-uZHqITpu9ZTI9/QaN9a5j6jY56SUyK84ydP8iDhL40c=";
    };
  };

  src = fetchurl (
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "orca-ide: unsupported system ${stdenvNoCC.hostPlatform.system}")
  );

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Agent development environment for running coding agents in parallel";
    longDescription = ''
      Orca runs coding agents such as Codex, Claude Code, OpenCode or Pi
      side-by-side, each in its own git worktree, and tracks them in one
      place. A mobile companion app can monitor and steer running agents.
    '';
    homepage = "https://www.onorca.dev/";
    changelog = "https://github.com/stablyai/orca/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ imcvampire ];
    mainProgram = "orca-ide";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

  linux = appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    nativeBuildInputs = [
      desktop-file-utils
      makeWrapper
    ];

    # Orca shells out to git for its worktrees and to ssh for remote sessions;
    # Electron dlopens libnotify for desktop notifications.
    extraPkgs = _: [
      git
      libnotify
      openssh
    ];

    extraInstallCommands = ''
      desktop-file-install --dir $out/share/applications \
        --set-key Exec --set-value '${pname} %U' \
        ${appimageContents}/${pname}.desktop

      mkdir -p $out/share
      cp -r ${appimageContents}/usr/share/icons $out/share/icons

      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    '';
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      makeWrapper
      unzip
    ];

    sourceRoot = "Orca.app";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications/Orca.app
      cp -R . $out/Applications/Orca.app

      makeWrapper $out/Applications/Orca.app/Contents/MacOS/Orca $out/bin/${pname}

      runHook postInstall
    '';

    # The bundle ships signed and notarized; rewriting anything inside it
    # invalidates the signature and macOS then refuses to launch it.
    dontFixup = true;
  };
in
if stdenvNoCC.hostPlatform.isLinux then linux else darwin
