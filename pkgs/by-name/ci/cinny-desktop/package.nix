{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri_1,
  cinny,
  desktop-file-utils,
  wrapGAppsHook3,
  pkg-config,
  openssl,
  glib-networking,
  webkitgtk_4_1,
  jq,
  moreutils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cinny-desktop";
  # We have to be using the same version as cinny-web or this isn't going to work.
  version = "4.10.2";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M1p8rwdNEsKvZ1ssxsFyfiIBS8tKrXhuz85CKM4dSRw=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  cargoHash = "sha256-Ie6xq21JoJ37j/BjdVrsiJ3JULVEV5ZwN3hf9NhfXVA=";

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
        'del(.tauri.updater) | .build.distDir = "${cinny'}" | del(.build.beforeBuildCommand)' tauri.conf.json \
        | ${lib.getExe' moreutils "sponge"} tauri.conf.json
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/bin"
      ln -sf "$out/Applications/Cinny.app/Contents/MacOS/Cinny" "$out/bin/cinny"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      desktop-file-edit \
        --set-comment "Yet another matrix client for desktop" \
        --set-key="Categories" --set-value="Network;InstantMessaging;" \
        $out/share/applications/cinny.desktop
    '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER "1"
    )
  '';

  nativeBuildInputs = [
    cargo-tauri_1.hook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    desktop-file-utils
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  meta = {
    description = "Yet another matrix client for desktop";
    homepage = "https://github.com/cinnyapp/cinny-desktop";
    maintainers = with lib.maintainers; [
      qyriad
      ryand56
    ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cinny";
    # Waiting for update to Tauri v2, webkitgtk_4_0 is deprecated
    # See https://github.com/cinnyapp/cinny-desktop/issues/398 and https://github.com/NixOS/nixpkgs/pull/450065
    broken = stdenv.hostPlatform.isLinux;
  };
})
