{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  copyDesktopItems,
  electron_39,
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
  podman,
}:

let
  electron = electron_39;
  appName = "Podman Desktop";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "podman-desktop";
  version = "1.23.1";

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    (lib.getExe (writeShellApplication {
      name = "podman-desktop-dependencies-updater";
      runtimeInputs = [
        nix
        jq
        gnugrep
      ];
      runtimeEnv = {
        PNAME = "podman-desktop";
        PKG_FILE = toString ./package.nix;
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
    hash = "sha256-08boCPsuT09OileZUWhB8awXWHrlJzoER2Bx0WXeOHU=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-nBjAmXzjR0qGCM91UAonQKP0NG7+DXImueSbhbnMK/k=";
  };

  patches = [
    # podman should be installed with nix; disable auto-installation
    ./extension-no-download-podman.patch
    ./system-defaults-dir.patch
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm_10.configHook
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pnpm build

    # Explicitly set identity to null to avoid signing on arm64 macs with newer electron-builder.
    # See: https://github.com/electron-userland/electron-builder/pull/9007
    ./node_modules/.bin/electron-builder \
      --dir \
      --config .electron-builder.config.cjs \
      -c.mac.identity=null \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase =
    let
      commonWrapperArgs = "--prefix PATH : ${lib.makeBinPath [ podman ]}";
    in
    (
      ''
        runHook preInstall

      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        mkdir -p "$out/Applications"
        mv dist/mac*/"${appName}.app" "$out/Applications"

        wrapProgram "$out/Applications/${appName}.app/Contents/MacOS/${appName}" \
          ${commonWrapperArgs}
      ''
      # Enforce X11 to avoid the Wayland dashboard issue.
      # Revisit this once issue https://github.com/podman-desktop/podman-desktop/issues/14388 is resolved.
      + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
        mkdir -p "$out/share/lib/podman-desktop"
        cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/podman-desktop"

        install -Dm644 buildResources/icon.svg "$out/share/icons/hicolor/scalable/apps/podman-desktop.svg"

        makeWrapper '${electron}/bin/electron' "$out/bin/podman-desktop" \
          --add-flags "$out/share/lib/podman-desktop/resources/app.asar" \
          --set XDG_SESSION_TYPE 'x11' \
          ${commonWrapperArgs} \
          --inherit-argv0
      ''
      + ''

        runHook postInstall
      ''
    );

  # see: https://github.com/containers/podman-desktop/blob/main/.flatpak.desktop
  desktopItems = [
    (makeDesktopItem {
      name = "podman-desktop";
      exec = "podman-desktop %U";
      icon = "podman-desktop";
      desktopName = appName;
      genericName = "Desktop client for podman";
      comment = finalAttrs.meta.description;
      categories = [ "Utility" ];
      startupWMClass = appName;
    })
  ];

  meta = {
    description = "Graphical tool for developing on containers and Kubernetes";
    homepage = "https://podman-desktop.io";
    changelog = "https://github.com/containers/podman-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      booxter
    ];
    inherit (electron.meta) platforms;
    mainProgram = "podman-desktop";
  };
})
