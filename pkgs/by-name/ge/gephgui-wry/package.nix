{
  lib,
  rustPlatform,
  webkitgtk_4_1,
  pkg-config,
  geph,
  buildNpmPackage,
  makeDesktopItem,
  fetchFromGitHub,
  nix-update-script,
  gtk3,
  libayatana-appindicator,
  xdotool,
  copyDesktopItems,
  wrapGAppsHook4,
}:
let
  version = "5.9.1";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "gephgui-pkg";
    tag = "v${version}";
    hash = "sha256-GP9kLtC3OrwHIfNena/wLDeWLkLGIOtvE5UpNUiSoco=";
    fetchSubmodules = true;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gephgui-wry";
  inherit version src;

  gephgui = buildNpmPackage {
    pname = "gephgui";
    inherit version src;

    sourceRoot = "${src.name}/gephgui-wry/gephgui";
    npmDepsHash = "sha256-sSnQ5gsg8LRY8De1jWtZqjxioJW8YSKCPGohCide6eE=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -aR dist/* $out/

      runHook postInstall
    '';
  };

  sourceRoot = "${src.name}/gephgui-wry";
  cargoHash = "sha256-+hnZAioFP2eRj5U0F190VESK7tyrdbzIsqERMupdssU=";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail 'std::env::var("FLATPAK_ID").is_err()' 'false'
  '';

  env.VERSION = version;

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
    webkitgtk_4_1
    xdotool
  ];

  preBuild = ''
    cp -r ${finalAttrs.gephgui}/ gephgui/dist/
  '';

  postInstall = ''
    install -m 444 -D gephgui/public/gephlogo.png $out/share/icons/hicolor/512x512/apps/geph.png
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ geph ]}
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libayatana-appindicator ]}
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Geph";
      desktopName = "Geph";
      icon = "geph";
      exec = "gephgui-wry";
      categories = [ "Network" ];
      comment = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
      startupWMClass = "geph";
    })
  ];

  passthru = {
    inherit (finalAttrs) gephgui;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage=gephgui"
      ];
    };
  };

  meta = {
    description = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
    homepage = "https://github.com/geph-official/gephgui-wry";
    mainProgram = "gephgui-wry";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      penalty1083
      MCSeekeri
    ];
  };
})
