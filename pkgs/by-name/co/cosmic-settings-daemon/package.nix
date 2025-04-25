{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libpulseaudio,
  geoclue2-with-demo-agent,
  libinput,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-settings-daemon";
  version = "1.0.0-alpha.7";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-vdhkE5CmgiGYg5TXxN7lLqxjv7apKEKvIscXFIzZfRc=";
  };

  postPatch = ''
    substituteInPlace src/battery.rs \
      --replace-fail '/usr/share/sounds/Pop/' '${pop-gtk-theme}/share/sounds/Pop/'
    substituteInPlace src/theme.rs \
      --replace-fail '/usr/share/themes/adw-gtk3' '${adw-gtk3}/share/themes/adw-gtk3'
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-Dzv1SDeZFIa+LFQQ91lO7RBHldsjDnGf+R12Ln2WZwU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libinput
    libpulseaudio
    udev
  ];

  postInstall = ''
    mkdir -p $out/share/polkit-1/rules.d
    cp data/polkit-1/rules.d/*.rules $out/share/polkit-1/rules.d/
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings Daemon for the COSMIC Desktop Environment";
    mainProgram = "cosmic-settings-daemon";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}
