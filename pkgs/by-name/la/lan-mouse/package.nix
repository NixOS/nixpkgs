{
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lib,
  glib,
  gtk4,
  libadwaita,
  libX11,
  libXtst,
  pkg-config,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "lan-mouse";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "feschber";
    repo = "lan-mouse";
    rev = "v${version}";
    hash = "sha256-ofiNgJbmf35pfRvZB3ZmMkCJuM7yYgNL+Dd5mZZqyNk=";
  };

  # lan-mouse uses `git` to determine the version at build time and
  # has Cargo set the `GIT_DESCRIBE` environment variable. To improve
  # build reproducibility, we define the variable based on the package
  # version instead.
  prePatch = ''
    rm build.rs
  '';
  env = {
    GIT_DESCRIBE = "${version}-nixpkgs";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libX11
    libXtst
  ];

  cargoHash = "sha256-RP3Jw0b2h8KJlVdd8X/AkkmGdRlIfG2tkPtUKohDxvA=";

  meta = {
    description = "Software KVM switch for sharing a mouse and keyboard with multiple hosts through the network";
    homepage = "https://github.com/feschber/lan-mouse";
    changelog = "https://github.com/feschber/lan-mouse/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "lan-mouse";
    maintainers = with lib.maintainers; [ pedrohlc ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
