{
  stdenv,
  lib,
  buildNpmPackage,
  electron_34,
  fetchFromGitHub,
  jq,
  makeDesktopItem,
}:

let
  electron = electron_34;
  description = "Visualizer for neural network, deep learning and machine learning models";
  icon = "netron";

in
buildNpmPackage rec {
  pname = "netron";
  version = "8.1.8";

  src = fetchFromGitHub {
    owner = "lutzroeder";
    repo = "netron";
    tag = "v${version}";
    hash = "sha256-h03nqBE82mw/XpUOnnQwUxhjXpBF9Ysc1fVTBQpMIS4=";
  };

  # Upstream doesn't ship package-lock.json in their sources
  # https://github.com/lutzroeder/netron/issues/1430
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-oS/s2ZcqynPTJDjoY4hIHEaBKyci/AfaCqpSHhBZB+s=";

  nativeBuildInputs = [
    jq
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  preBuild = ''
    if [[ $(jq --raw-output '.devDependencies.electron' < package.json | grep -E --only-matching '^[0-9]+') != ${lib.escapeShellArg (lib.versions.major electron.version)} ]]; then
      echo 'ERROR: electron version mismatch'
      exit 1
    fi
  '';

  # Do not run the default build script, it tries to do way too much that
  # wouldn't work on NixOS and require patching.
  dontNpmBuild = true;

  postBuild = ''
    npm exec electron-builder -- \
      --dir \
      --c.electronDist=${electron.dist} \
      --c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out

    pushd dist/linux-${lib.optionalString stdenv.hostPlatform.isAarch64 "arm64-"}unpacked
    mkdir -p $out/opt/netron
    cp -r locales resources{,.pak} $out/opt/netron
    popd

    makeWrapper '${lib.getExe electron}' "$out/bin/netron" \
      --add-flags $out/opt/netron/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    pushd source
    for icon in icon.*; do
      dir=$out/share/icons/hicolor/"''${icon%.*}"/apps
      mkdir -p "$dir"
      cp "$icon" "$dir"/${icon}.png
    done
    popd

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Netron";
      exec = "netron %U";
      inherit icon;
      comment = description;
      desktopName = "Netron";
      categories = [ "Development" ];
    })
  ];

  meta = {
    changelog = "https://github.com/lutzroeder/netron/releases/tag/v${version}";
    inherit description;
    homepage = "https://netron.app";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
    mainProgram = "netron";
    platforms = electron.meta.platforms;
    badPlatforms = [
      # Fails on darwin
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
