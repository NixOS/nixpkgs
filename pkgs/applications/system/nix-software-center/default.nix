{ pkgs
, lib
, stdenv
, callPackage
, fetchFromGitHub
, appstream-glib
, polkit
, gettext
, desktop-file-utils
, meson
, ninja
, pkg-config
, git
, wrapGAppsHook4
, rustPlatform
, gdk-pixbuf
, glib
, gtk4
, gtksourceview5
, libadwaita
, libxml2
, openssl
, wayland
, gnome
, gnome-console
, sqlite
, cargo
, rustc
}:
let
  nixos-appstream-data = callPackage ./nixos-appstream-data.nix { };
in
stdenv.mkDerivation rec {
  pname = "nix-software-center";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "vlinkz";
    repo = "nix-software-center";
    rev = "refs/tags/${version}";
    hash = "sha256-xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nix-data-0.0.2" = "sha256-yts2bkp9cn4SuYPYjgTNbOwTtpFxps3TU8zmS/ftN/Q=";
    };
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
  ] ++ (with rustPlatform; [ cargoSetupHook ]);

  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
    gtksourceview5
    libadwaita
    libxml2
    openssl
    wayland
    gnome.adwaita-icon-theme
    desktop-file-utils
    nixos-appstream-data
  ];

  patchPhase = ''
    substituteInPlace ./src/lib.rs \
        --replace "/usr/share/app-info" "${nixos-appstream-data}/share/app-info"
  '';

  postInstall = ''
    wrapProgram $out/bin/nix-software-center --prefix PATH : '${lib.makeBinPath [ gnome-console sqlite ]}'
  '';

  meta = with lib; {
    description = "A graphical app store for Nix built with libadwaita, GTK4, and Relm4";
    longDescription = ''
      - Install packages to 'configuration.nix'
      - Flakes support can be enabled in the preferences menu
      - Install packages with nix profile or 'nix-env'
      - Show updates for all installed packages
      - Search for packages
      - Launch applications without installing via 'nix-shell' and nix run
    '';
    homepage = "https://github.com/vlinkz/nix-software-center";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sund3RRR ];
  };
}
