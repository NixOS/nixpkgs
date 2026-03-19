{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  cinny,
  desktop-file-utils,
  wrapGAppsHook3,
  makeBinaryWrapper,
  pkg-config,
  openssl,
  glib-networking,
  webkitgtk_4_1,
  jq,
  moreutils,
  nix-update-script,
  _experimental-update-script-combinators,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cinny-desktop";
  # We have to be using the same version as cinny-web or this isn't going to work.
  version = "4.11.1";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/zHXlAqIxWN1obFO3H/eqFj38pjopF4D5ooz0YiVgD0=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  cargoHash = "sha256-bchjUTC0/hWPf/cOs+cxRbqho/B9LMJ3ChW530zEoXU=";

  postPatch =
    let
      cinny' =
        assert lib.assertMsg (
          cinny.version == finalAttrs.version
        ) "cinny.version (${cinny.version}) != cinny-desktop.version (${finalAttrs.version})";
        cinny.override {
          conf = {
            hashRouter.enabled = true;
          };
        };
    in
    ''
      ${lib.getExe jq} \
        'del(.plugins.tauri.updater) | .build.frontendDist = "${cinny'}" | del(.build.beforeBuildCommand) | .bundle.createUpdaterArtifacts = false' tauri.conf.json \
        | ${lib.getExe' moreutils "sponge"} tauri.conf.json
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/bin"
      makeWrapper "$out/Applications/Cinny.app/Contents/MacOS/Cinny" "$out/bin/cinny"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      desktop-file-edit \
        --set-comment "Yet another matrix client for desktop" \
        --set-key="Categories" --set-value="Network;InstantMessaging;" \
        $out/share/applications/Cinny.desktop
    '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER "1"
    )
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    desktop-file-utils
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { attrPath = "cinny-unwrapped"; })
      (nix-update-script { })
    ];
  };

  meta = {
    description = "Yet another matrix client for desktop";
    homepage = "https://github.com/cinnyapp/cinny-desktop";
    maintainers = with lib.maintainers; [
      qyriad
      rebmit
      ryand56
    ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cinny";
  };
})
