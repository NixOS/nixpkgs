{ pkgs
, stdenv
, lib
, desktop-file-utils
, gdk-pixbuf
, gtk4
, gtksourceview5
, libadwaita
, meson
, ninja
, openssl
, pkg-config
, polkit
, wrapGAppsHook4
, rustPlatform
, fetchFromGitHub
, callPackage
, appstream-glib
, gettext
, git
, glib
, libxml2
, wayland
, adwaita-icon-theme
, cargo
, rustc

}:
let nixos-appstream-data = callPackage ./nixos-appstream-data.nix { };
in stdenv.mkDerivation (finalAttrs: rec {
  pname = "software-center";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "xinux-org";
    repo = "software-center";
    tag = version;
    hash = "sha256-KwdctGfzR2H8GbAL7OWizM2Y6afoQEJKjuffUS1mmnI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-QIV/X6zfZUKmMSnu6KdTCLiEWMm2zApPqQobs8QEsAk=";
  };

  nativeBuildInputs = [
    appstream-glib
    polkit
    gettext
    desktop-file-utils
    meson
    ninja
    pkg-config
    git
    wrapGAppsHook4
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
    gtksourceview5
    libadwaita
    libxml2
    openssl
    wayland
    adwaita-icon-theme
    desktop-file-utils
    nixos-appstream-data
  ];

  patchPhase = ''
    substituteInPlace ./src/lib.rs \
        --replace "/usr/share/app-info" "${nixos-appstream-data}/share/app-info"
  '';

  postInstall = ''
    wrapProgram $out/bin/nix-software-center --prefix PATH : '${
      lib.makeBinPath [
        pkgs.gnome-console
        pkgs.gtk3 # provides gtk-launch
        pkgs.sqlite
      ]
    }'
  '';

  meta = {
    homepage = "https://github.com/xinux-org/software-center";
    mainProgram = "Software Center";
    description =
      "A simple gtk4/libadwaita software center to easily install and manage nix packages";
    license = with lib.licenses; [ gpl3 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ orzklv bahrom04 ];
  };
})
