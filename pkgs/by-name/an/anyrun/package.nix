{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, atk
, cairo
, gdk-pixbuf
, glib
, gtk3
, pango
, stdenv
, darwin
, wayland
, gtk-layer-shell
, unstableGitUpdater
}:

rustPlatform.buildRustPackage rec {
  pname = "anyrun";
  version = "0-unstable-2023-12-01";

  src = fetchFromGitHub {
    owner = "kirottu";
    repo = "anyrun";
    rev = "e14da6c37337ffa3ee1bc66965d58ef64c1590e5";
    hash = "sha256-hI9+KBShsSfvWX7bmRa/1VI20WGat3lDXmbceMZzMS4=";
  };

  cargoHash = "sha256-apOQc9Z6YANoaeKcbNxBfAv7mmGFB+CagrYRPgC5wLY=";

  strictDeps = true;
  enableParallelBuilding = true;
  doCheck = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    gtk-layer-shell
    pango
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ] ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  preFixup = ''
    gappsWrapperArgs+=(
     --prefix ANYRUN_PLUGINS : $out/lib
    )
  '';

  postInstall = ''
    install -Dm444 anyrun/res/style.css examples/config.ron -t $out/share/doc/anyrun/examples/
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Wayland-native, highly customizable runner";
    homepage = "https://github.com/kirottu/anyrun";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "anyrun";
  };
}
