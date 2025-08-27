{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libayatana-appindicator,
  gtk3,
}:

buildGoModule rec {
  pname = "matebook-applet";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "nekr0z";
    repo = "matebook-applet";
    tag = "v${version}";
    hash = "sha256-/ysxtYljp2B4CtVJxijsu6dykS0Gz3t02FFcB4E4jH4=";
  };

  vendorHash = "sha256-lnkU0FiEothUQyj5JQZLoh6IcovKeB9UACHx73siMcY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libayatana-appindicator
    gtk3
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    install -Dm644 matebook-applet.desktop -t "$out/share/applications/"
    install -Dm644 assets/matebook-applet.png -t "$out/share/icons/hicolor/512x512/apps/"
    install -Dm644 matebook-applet.1 -t "$out/share/man/man1/"
  '';

  meta = {
    description = "System tray applet/control app for Huawei Matebook";
    homepage = "https://github.com/nekr0z/matebook-applet";
    changelog = "https://github.com/nekr0z/matebook-applet/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sandarukasa ];
    mainProgram = "matebook-applet";
  };
}
