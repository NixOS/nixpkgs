{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  wrapGAppsHook4,
  libadwaita,
  openssl,
  libgit2,
  xvfb-run,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stage";
  version = "0.1.23";

  src = fetchFromGitHub {
    owner = "aganzha";
    repo = "stage";
    tag = finalAttrs.version;
    hash = "sha256-UqGEFisVi912xMHY+FcrWBjCTu+gauUSkwkmC1AU4Xg=";
  };

  cargoHash = "sha256-6yButpKGT7bpEAOlC7zMkrt/B6bxzwpGGkxm9IucPkA=";

  nativeBuildInputs = [
    pkg-config
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    openssl
    libgit2
  ];

  nativeCheckInputs = [ xvfb-run ];

  # Enable recursive lookup because we append schema path in XDG_DATA_DIRS
  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail "system_schema_source.lookup(APP_ID, false)" "system_schema_source.lookup(APP_ID, true)"
  '';

  preBuild = ''
    glib-compile-resources io.github.aganzha.Stage.gresource.xml --target src/gresources.compiled
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run cargo test
    runHook postCheck
  '';

  postInstall = ''
    install -Dm644 io.github.aganzha.Stage.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas
    install -Dm644 io.github.aganzha.Stage.metainfo.xml -t $out/share/metainfo
    install -Dm644 io.github.aganzha.Stage.desktop -t $out/share/applications
    for width in 16 32 48 64 128 256 512; do
      size="''${width}x''${width}"
      install -Dm644 icons/$size/io.github.aganzha.Stage.png -t $out/share/icons/hicolor/$size/apps
    done
    install -Dm644 icons/io.github.aganzha.Stage.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 icons/io.github.aganzha.Stage-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps
    install -Dm644 icons/org.gnome.Logs-symbolic.svg -t $out/share/icons/hicolor/symbolic/apps
  '';

  env = {
    LIBGIT2_NO_VENDOR = 1;
    OUT_DIR = "."; # For gio::resources_register_include!("gresources.compiled")
  };

  meta = {
    description = "Git GUI client for linux desktops inspired by Magit";
    homepage = "https://github.com/aganzha/stage";
    license = lib.licenses.gpl3Plus;
    mainProgram = "stage";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
