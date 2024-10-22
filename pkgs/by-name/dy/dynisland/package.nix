{
  lib,
  rustPlatform,
  fetchFromGitHub,
  dbus,
  openssl,
  gtk4,
  gtk4-layer-shell,
  glib,
  pkg-config,
  wrapGAppsHook4,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dynisland";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "cr3eperall";
    repo = "dynisland";
    rev = "refs/tags/${version}";
    hash = "sha256-HqwykR6BXxtYSxNUYdegmjCwSVTW29pqP7qLWbcqLeg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-p67h67fRNcfiQyhCUY5Y11xTTqQbl0Ngx1EhYfaSJmw=";

  buildFeatures = [ "completions" ];

  buildInputs = [
    dbus
    openssl
    gtk4
    gtk4-layer-shell
  ];

  nativeBuildInputs = [
    glib
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    pkg-config
    wrapGAppsHook4
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd dynisland \
      --bash ./target/dynisland.bash \
      --fish ./target/dynisland.fish \
      --zsh ./target/_dynisland
  '';

  meta = {
    description = "Dynamic and extensible GTK4 layer-shell, written in Rust";
    homepage = "https://github.com/cr3eperall/dynisland";
    changelog = "https://github.com/cr3eperall/dynisland/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryand56 ];
    mainProgram = "dynisland";
    platforms = lib.platforms.linux;
  };
}
