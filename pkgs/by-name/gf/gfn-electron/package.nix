{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  nix-update-script,
  makeBinaryWrapper,
}:
let
  version = "2.1.2";
in
buildNpmPackage {
  pname = "gfn-electron";
  inherit version;

  src = fetchFromGitHub {
    owner = "hmlendea";
    repo = "gfn-electron";
    rev = "refs/tags/v${version}";
    hash = "sha256-kTnM4wSDqP2V8hb4mDhbQYpVYouSnUkjuuCfITb/xgY=";
  };

  npmDepsHash = "sha256-27N0hWOfkLQGaGspm4aCoVF6PWiUOAKs+JzbdQV94lo=";

  nativeBuildInputs = [ makeBinaryWrapper ];

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
