{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, gdk-pixbuf
, glib
, gtk4
, libadwaita
, libepoxy
, libGL
, copyDesktopItems
, installShellFiles
}:

rustPlatform.buildRustPackage rec {

  pname = "satty";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "gabm";
    repo = "Satty";
    rev = "v${version}";
    hash = "sha256-4upjVP7DEWD76wycmCQxl86nsJYI0+V7dSThRFJu9Ds=";
  };

  cargoHash = "sha256-z2hRSGAwCI6DiXP87OzyyhJYjdB/7hSxYlUsKij1WQk=";

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook4
    installShellFiles
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    libepoxy
    libGL
  ];

  postInstall = ''
    install -Dt $out/share/icons/hicolor/scalable/apps/ assets/satty.svg

    installShellCompletion --cmd satty \
      --bash completions/satty.bash \
      --fish completions/satty.fish \
      --zsh completions/_satty
  '';

  desktopItems = [ "satty.desktop" ];

  meta = with lib; {
    description = "Screenshot annotation tool inspired by Swappy and Flameshot";
    homepage = "https://github.com/gabm/Satty";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pinpox donovanglover ];
    mainProgram = "satty";
    platforms = lib.platforms.linux;
  };
}
