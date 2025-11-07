{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  libadwaita,
  vte-gtk4,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ivyterm";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "Tomiyou";
    repo = "ivyterm";
    tag = "v${version}";
    hash = "sha256-Xr4oXg+kZPDImY7BlKUHwgi5AtCArH1vf3+s117luTQ=";
  };

  cargoHash = "sha256-aBo+IAM+tAzUazw9XE80EACWyQtDIQjm33Q20p49L5s=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
    libadwaita
    vte-gtk4
  ];

  postInstall = ''
    install -D data/com.tomiyou.ivyTerm.desktop -t $out/share/applications
    install -D data/com.tomiyou.ivyTerm.svg -t $out/share/icons
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal emulator implemented in gtk4-rs and VTE4";
    homepage = "https://github.com/Tomiyou/ivyterm";
    changelog = "https://github.com/Tomiyou/ivyterm/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "ivyterm";
  };
}
