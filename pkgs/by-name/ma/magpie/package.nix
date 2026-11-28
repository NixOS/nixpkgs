{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  webkitgtk_6_0,
  xdg-utils,
  glib-networking,
  bun,
  makeBinaryWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  versionCheckHook,
  # False builds the terminal-only magpie-cli.
  withGui ? true,
}:

buildGoModule (finalAttrs: {
  pname = "magpie" + lib.optionalString (!withGui) "-cli";
  version = "0.1.4972";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yetone";
    repo = "magpie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Nbge/7ZHOX90jg4QmZAISWh/uQmCKvZVQ2KhQtsmi/M=";
  };

  vendorHash = "sha256-jSDYFsMfJqpI6t4gCXfUv+SzD0J6V/X0Y/Y8UDPrpoo=";

  subPackages = [ "." ];

  env.CGO_ENABLED = if withGui then "1" else "0";

  # Upstream's Makefile adds gtk3 on Linux for older distributions; this
  # uses the default GTK 4 / WebKitGTK 6 backend instead.
  tags = if withGui then [ "production" ] else [ "nogui" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs =
    lib.optionals withGui [
      pkg-config
      wrapGAppsHook4
      copyDesktopItems
    ]
    # The GUI is wrapped by wrapGAppsHook4; the CLI needs a wrapper of its
    # own for MAGPIE_BUN and xdg-open.
    ++ lib.optionals (!withGui) [ makeBinaryWrapper ];

  buildInputs = lib.optionals withGui [
    gtk4
    webkitgtk_6_0
    # libsoup's HTTPS is the GIO TLS module. Without it the window loads
    # local pages, then fails every remote image and request.
    glib-networking
  ];

  # Tests need a real GUI and keychain; versionCheckHook runs the binary.
  doCheck = false;

  # The entry and icons magpie would otherwise write into $HOME on first start.
  desktopItems = lib.optionals withGui [
    (makeDesktopItem {
      name = "magpie";
      desktopName = "magpie";
      genericName = "Model picker";
      comment = "Every agent's model. One place.";
      exec = "magpie %u";
      icon = "magpie";
      terminal = false;
      categories = [
        "Development"
        "Utility"
      ];
      mimeTypes = [ "x-scheme-handler/magpie" ];
      startupWMClass = "magpie";
    })
  ];

  postInstall =
    lib.optionalString withGui ''
      install -Dm644 internal/gui/icon-256.png \
        "$out/share/icons/hicolor/256x256/apps/magpie.png"
      install -Dm644 internal/gui/icon-1024.png \
        "$out/share/icons/hicolor/1024x1024/apps/magpie.png"
      install -Dm644 build/icon/magpie.svg \
        "$out/share/icons/hicolor/scalable/apps/magpie.svg"
    ''
    + ''
      install -Dm644 LICENSE "$out/share/licenses/${finalAttrs.pname}/LICENSE"
    '';

  # wrapGAppsHook4 only collects gappsWrapperArgs; wrapping happens below.
  dontWrapGApps = withGui;

  postFixup =
    lib.optionalString withGui ''
      wrapProgram "$out/bin/magpie" "''${gappsWrapperArgs[@]}" \
        --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
        --set-default MAGPIE_BUN ${lib.getExe bun} \
        --set MAGPIE_EXECUTABLE ${placeholder "out"}/bin/magpie
      chmod +w "$out/share/applications/magpie.desktop"
      substituteInPlace "$out/share/applications/magpie.desktop" \
        --replace-fail 'Exec=magpie %u' "Exec=$out/bin/magpie %u"
    ''
    + lib.optionalString (!withGui) ''
      wrapProgram "$out/bin/magpie" \
        --set-default MAGPIE_BUN ${lib.getExe bun} \
        --set MAGPIE_EXECUTABLE ${placeholder "out"}/bin/magpie \
        --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    # Tags also include pf-v1 through pf-v4; only vX.Y.Z is a release.
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description =
      "Pick the model each AI coding agent on your machine uses"
      + lib.optionalString (!withGui) " (terminal build)";
    homepage = "https://usemagpie.ai/";
    changelog = "https://github.com/yetone/magpie/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "magpie";
    maintainers = [ lib.maintainers.myul ];
    # bun is a build input and the plugin runtime; it is not available on
    # every platform this would otherwise claim.
    platforms = lib.intersectLists lib.platforms.linux bun.meta.platforms;
  };
})
