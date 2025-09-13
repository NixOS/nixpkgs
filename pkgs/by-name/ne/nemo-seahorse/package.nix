{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  glib,
  gtk3,
  nemo,
  cmake,
  dbus-glib,
  libcryptui,
  gcr,
  libnotify,
  gnupg,
  gpgme,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "nemo-seahorse";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    tag = version;
    hash = "sha256-39hWA4SNuEeaPA6D5mWMHjJDs4hYK7/ZdPkTyskvm5Y=";
  };

  sourceRoot = "${src.name}/nemo-seahorse";

  patches = [ ./fix-schemas.patch ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    cmake
  ];

  buildInputs = [
    glib
    gtk3
    nemo
    gpgme
    dbus-glib
    libcryptui
    gcr
    libnotify
    gnupg
  ];

  PKG_CONFIG_LIBNEMO_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/${nemo.extensiondir}";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-seahorse";
    changelog = "https://github.com/linuxmint/nemo-extensions/blob/master/nemo-seahorse/ChangeLog";
    description = "Nemo seahorse extension";
    longDescription = ''
      You can add the extension to nemo using the following configuration:
      ```nix
      {
        environment.systemPackages = with pkgs; [
          (nemo-with-extensions.override {
            extensions = [ nemo-seahorse ];
          })
        ];

        services.dbus.packages = with pkgs; [
          libcryptui
        ];

        services.desktopManager.gnome.extraGSettingsOverridePackages = with pkgs; [
          nemo
          gcr
          libcryptui
          nemo-seahorse
        ];
      }
      ```
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
