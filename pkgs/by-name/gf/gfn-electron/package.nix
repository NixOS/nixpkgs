{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron_35,
  nix-update-script,
  makeBinaryWrapper,
  python3,
}:
let
  electron = electron_35;
  version = "2.2.0";
in
buildNpmPackage {
  pname = "gfn-electron";
  inherit version;

  src = fetchFromGitHub {
    owner = "hmlendea";
    repo = "gfn-electron";
    tag = "v${version}";
    hash = "sha256-DwrNCgBp0CD+HYXRMDsu0aKEKzG7k/tk7oATJc30DlE=";
  };

  npmDepsHash = "sha256-2v5qTTGhdG1EEK8v50LLYz5jE/36lBm1PKQl6HfqhCU=";

  nativeBuildInputs = [
    makeBinaryWrapper
    # node_modules/node-gyp/gyp/pylib/gyp/input.py
    #   from distutils.version import StrictVersion
    # ModuleNotFoundError: No module named 'distutils'
    (python3.withPackages (ps: with ps; [ setuptools ]))
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  # FIXME: Git dependency node_modules/register-scheme contains install scripts,
  # but has no lockfile, which is something that will probably break.
  forceGitDeps = true;

  makeCacheWritable = true;

  buildPhase = ''
    runHook preBuild

    # NOTE: Upstream explicitly opts to not build an ASAR as it would cause all
    # text to disappear in the app.
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/*-unpacked $out/dist

    install -Dm644 com.github.hmlendea.geforcenow-electron.desktop -t $out/share/applications
    install -Dm644 icon.png $out/share/icons/hicolor/512x512/apps/geforcenow-electron.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/dist/geforcenow-electron $out/bin/geforcenow-electron \
      --add-flags "--no-sandbox --disable-gpu-sandbox" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    substituteInPlace $out/share/applications/com.github.hmlendea.geforcenow-electron.desktop \
      --replace-fail "/opt/geforcenow-electron/geforcenow-electron" "geforcenow-electron" \
      --replace-fail "Icon=nvidia" "Icon=geforcenow-electron"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux Desktop client for Nvidia's GeForce NOW game streaming service";
    homepage = "https://github.com/hmlendea/gfn-electron";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.intersectLists lib.platforms.linux electron.meta.platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "geforcenow-electron";
  };
}
