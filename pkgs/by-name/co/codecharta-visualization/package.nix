{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  dart-sass,
  nodejs_24,
  # upstream pins electron 44
  electron_44,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

let
  electron = electron_44;
in
buildNpmPackage (finalAttrs: {
  pname = "codecharta-visualization";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "MaibornWolff";
    repo = "codecharta";
    tag = "vis-${finalAttrs.version}";
    hash = "sha256-gUkgVrQdYfbq/qj0yuAR0lR2Gw2p4sZpPsl5IlVWvUM=";
  };

  sourceRoot = "${finalAttrs.src.name}/visualization";

  nodejs = nodejs_24;

  npmDepsHash = "sha256-eRMua12eYcZB4VpGPOYRbQ85pyA8RlIaUH2ZcvdHD+I=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NG_CLI_ANALYTICS = "false";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  # `npm run build` applies patch-package, runs `ng build` and copies the
  # electron entry point and package.json next to the bundle
  npmBuildScript = "build";

  # sass-embedded's bundled Dart compiler won't run in the sandbox; use nixpkgs' dart-sass.
  # https://github.com/sass/embedded-host-node/issues/334
  preBuild = ''
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail \
        'compilerCommand = (() => {' \
        'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/codecharta-visualization
    cp -r dist/bundler/browser/. $out/share/codecharta-visualization/

    makeWrapper ${lib.getExe electron} $out/bin/codecharta-visualization \
      --add-flags $out/share/codecharta-visualization \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    install -Dm644 public/codeCharta/assets/icon.png \
      $out/share/icons/hicolor/1024x1024/apps/codecharta.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "codecharta";
      exec = "codecharta-visualization";
      icon = "codecharta";
      desktopName = "CodeCharta";
      comment = finalAttrs.meta.description;
      categories = [
        "Development"
      ];
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "vis-(.*)"
    ];
  };

  meta = {
    description = "3D city map visualization of code metrics";
    homepage = "https://codecharta.com";
    changelog = "https://github.com/MaibornWolff/codecharta/blob/vis-${finalAttrs.version}/visualization/CHANGELOG.md";
    license = lib.licenses.bsd3;
    mainProgram = "codecharta-visualization";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    inherit (electron.meta) platforms;
  };
})
