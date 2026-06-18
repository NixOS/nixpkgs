{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  electron_41,
  nodejs-slim_24,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
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
  nodejs-slim = nodejs-slim_24;
  pnpm = pnpm_10.override { inherit nodejs-slim; };
  electron = electron_41;
  appName = "Podman Desktop";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "podman-desktop";
  version = "1.27.2";

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
        get_major_version() {
          jq -r "$1" "$new_src/package.json" | grep --perl-regexp --only-matching '[0-9]+' | head -n 1
        }

        new_node_major="$(get_major_version '.engines.node')"
        new_electron_major="$(get_major_version '.devDependencies.electron')"
        new_pnpm_major="$(get_major_version '.packageManager')"

        sed -i -E "s/nodejs_[0-9]+/nodejs_$new_node_major/g" "$PKG_FILE"
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
    owner = "podman-desktop";
    repo = "podman-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HcT33KjWnoY/pGuolt0BZurxdaWgUTF0tuACE9flfCM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-FD5lXAgA6uJLRLbaiZDbmow6BEiF6DWCzryAzyMGKe8=";
  };

  patches = [
    # podman should be installed with nix; disable auto-installation
    ./extension-no-download-podman.patch
    ./system-defaults-dir.patch
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_OVERRIDE_DIST_PATH = electron.dist;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs-slim
    nodejs-slim.npm
    pnpm
    pnpmConfigHook
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

        # Derive the .desktop entry from upstream to keep it aligned and avoid regressions.
        install -Dm644 .flatpak.desktop "$out/share/applications/podman-desktop.desktop"
        substituteInPlace "$out/share/applications/podman-desktop.desktop" \
          --replace-fail 'Exec=run.sh %U' 'Exec=podman-desktop %U' \
          --replace-fail 'Icon=io.podman_desktop.PodmanDesktop' 'Icon=podman-desktop'
        sed -i '/^X-Flatpak=/d' "$out/share/applications/podman-desktop.desktop"

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

  meta = {
    description = "Graphical tool for developing on containers and Kubernetes";
    homepage = "https://podman-desktop.io";
    changelog = "https://github.com/podman-desktop/podman-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      booxter
    ];
    inherit (electron.meta) platforms;
    mainProgram = "podman-desktop";
  };
})
