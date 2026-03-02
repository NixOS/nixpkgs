{
  lib,
  rustPlatform,
  fetchFromGitLab,
  nix-update-script,
  pkg-config,
  libadwaita,
  gtk4,
  glib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "startup-disk";
  version = "0.1.5";

  src = fetchFromGitLab {
    owner = "davide125";
    repo = "startup-disk";
    tag = finalAttrs.version;
    hash = "sha256-258whEX6hKqfrk2aII15tuFEuB7NQUCNLEmi3OCOWV4=";
    domain = "gitlab.gnome.org";
  };

  nativeBuildInputs = [
    pkg-config
    glib # glib-compile-resources
  ];

  buildInputs = [
    libadwaita
    gtk4
    glib
  ];

  postPatch = ''
    # Fix sudo crate's hardcoded /usr/bin/sudo
    substituteInPlace $cargoDepsCopy/sudo-0.6.0/src/lib.rs \
      --replace-fail 'Command::new("/usr/bin/sudo")' 'Command::new("sudo")'
  '';

  cargoHash = "sha256-Ec2u/F/lVdT5Oi8N116kVWtp7duZTU0d5zOhYungJ/U=";

  postInstall = ''
    install -Dm644 res/org.startup_disk.StartupDisk.desktop -t $out/share/applications/
    install -Dm644 res/org.startup_disk.StartupDisk.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm644 res/org.startup_disk.StartupDisk.metainfo.xml -t $out/share/metainfo/
    install -Dm644 res/org.startup_disk.StartupDisk.policy -t $out/share/polkit-1/actions/
  '';

  postFixup = ''
    substituteInPlace $out/share/polkit-1/actions/org.startup_disk.StartupDisk.policy \
      --replace-fail /usr/bin/startup-disk /run/current-system/sw/bin/startup-disk
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interface to choose the startup volume on Apple Silicon systems";
    homepage = "https://gitlab.gnome.org/davide125/startup-disk";
    changelog = "https://gitlab.gnome.org/davide125/startup-disk/-/tags/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "startup-disk";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ milomc123 ];
  };
})
