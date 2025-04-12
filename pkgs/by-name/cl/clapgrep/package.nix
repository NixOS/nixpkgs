{
  lib,
  rustPlatform,
  fetchFromGitHub,

  wrapGAppsHook4,
  pkg-config,
  blueprint-compiler,

  gtk4,
  libadwaita,
  glib,

  nix-update-script,
}:
let
  version = "1.3.1";
  appid = "de.leopoldluley.Clapgrep";
in
rustPlatform.buildRustPackage {
  pname = "clapgrep";
  inherit version;

  src = fetchFromGitHub {
    owner = "luleyleo";
    repo = "clapgrep";
    rev = "refs/tags/v${version}";
    hash = "sha256-MYV8MrCIpa8eqp2iCLTNLZrVQOyGsMEGqlnEF43fyls=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tpWv8CznTxoAgOf0mb99peqUTQSfv+16dAmX8n7XVDQ=";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
    blueprint-compiler
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
  ];

  env.APP_ID = appid;

  # see Justfile
  postInstall = ''
    mv $out/bin/clapgrep-gnome $out/bin/clapgrep
    install -D assets/${appid}.desktop -t $out/share/applications
    install -D assets/${appid}.metainfo.xml -t $out/share/metainfo
    install -D assets/icons/hicolor/scalable/apps/${appid}.svg -t $out/share/icons/hicolor/scalable/apps

    mkdir -p assets/locale
    cat po/LINGUAS | while read lang; do
      mkdir -p assets/locale/$lang/LC_MESSAGES;
      msgfmt -o assets/locale/$lang/LC_MESSAGES/${appid}.mo po/$lang.po;
    done
    cp -r assets/locale -t $out/share
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Search through all your files";
    homepage = "https://github.com/luleyleo/clapgrep";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "clapgrep";
  };
}
