{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  copyDesktopItems,
  electron_35,
  nodejs,
  pnpm_10,
  makeDesktopItem,
  darwin,
  nix-update-script,
  _experimental-update-script-combinators,
  writeShellApplication,
  nix,
  jq,
  gnugrep,
}:

let
  electron = electron_35;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "podman-desktop";
  version = "1.18.1";

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    (lib.getExe (writeShellApplication {
      name = "${finalAttrs.pname}-dependencies-updater";
      runtimeInputs = [
        nix
        jq
        gnugrep
      ];
      runtimeEnv = {
        PNAME = finalAttrs.pname;
        PKG_FILE = builtins.toString ./package.nix;
      };
      text = ''
        new_src="$(nix-build --attr "pkgs.$PNAME.src" --no-out-link)"
        new_electron_major="$(jq '.devDependencies.electron' "$new_src/package.json" | grep --perl-regexp --only-matching '\d+' | head -n 1)"
        new_pnpm_major="$(jq '.packageManager' "$new_src/package.json" | grep --perl-regexp --only-matching '\d+' | head -n 1)"
        sed -i -E "s/electron_[0-9]+/electron_$new_electron_major/g" "$PKG_FILE"
        sed -i -E "s/pnpm_[0-9]+/pnpm_$new_pnpm_major/g" "$PKG_FILE"
      '';
    }))
    (nix-update-script {
      # Changing the pnpm version requires updating `pnpmDeps.hash`.
      extraArgs = [ "--version=skip" ];
    })
  ];

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GYdetO/WiEQAvVSvu81tKqkOH7YUgkB7RVW0Crd/2ww=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-IjCO2mLDHhb1fB92plBAFcH1RpmOtiUGlFHEEAAHOJ8=";
  };

  patches = [
    # podman should be installed with nix; disable auto-installation
    ./extension-no-download-podman.patch
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # Don't attempt to sign the darwin app bundle.
  # It's impure and may fail in some restricted environments.
  CSC_IDENTITY_AUTO_DISCOVERY = lib.optionals stdenv.hostPlatform.isDarwin "false";

  nativeBuildInputs =
    [
      nodejs
      pnpm_10.configHook
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      copyDesktopItems
      makeWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.autoSignDarwinBinariesHook
    ];

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pnpm build
    ./node_modules/.bin/electron-builder \
      --dir \
      --config .electron-builder.config.cjs \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase =
    ''
      runHook preInstall

    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv dist/mac*/Podman\ Desktop.app $out/Applications
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      mkdir -p "$out/share/lib/podman-desktop"
      cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/podman-desktop"

      install -Dm644 buildResources/icon.svg "$out/share/icons/hicolor/scalable/apps/podman-desktop.svg"

      makeWrapper '${electron}/bin/electron' "$out/bin/podman-desktop" \
        --add-flags "$out/share/lib/podman-desktop/resources/app.asar" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --inherit-argv0
    ''
    + ''

      runHook postInstall
    '';

  # see: https://github.com/containers/podman-desktop/blob/main/.flatpak.desktop
  desktopItems = [
    (makeDesktopItem {
      name = "podman-desktop";
      exec = "podman-desktop %U";
      icon = "podman-desktop";
      desktopName = "Podman Desktop";
      genericName = "Desktop client for podman";
      comment = finalAttrs.meta.description;
      categories = [ "Utility" ];
      startupWMClass = "Podman Desktop";
    })
  ];

  meta = {
    description = "A graphical tool for developing on containers and Kubernetes";
    homepage = "https://podman-desktop.io";
    changelog = "https://github.com/containers/podman-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      booxter
      panda2134
    ];
    inherit (electron.meta) platforms;
    mainProgram = "podman-desktop";
  };
})
