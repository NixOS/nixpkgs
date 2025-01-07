{
  fetchFromGitHub,
  lib,
  libcosmicAppHook,
  libinput,
  mesa,
  pkg-config,
  rustPlatform,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-workspaces-epoch";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-UKVxiFLZ1zHVKXvrwnZ+MSnFfq4WSZ8ulyfSgiIdq7M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QRBgFTXPWQ0RCSfCA2WpBs+vKTFD7Xfz60cIDtbYb5Y=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];

  buildInputs = [
    libinput
    mesa
    udev
  ];

  postInstall = ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp data/*.desktop $out/share/applications/
    cp data/*.svg $out/share/icons/hicolor/scalable/apps/
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-workspaces";

    maintainers = with maintainers; [
      nyabinary
      thefossguy
    ];
  };
}
