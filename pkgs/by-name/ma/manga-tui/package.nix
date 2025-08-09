{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
  perl,
  cacert,
  nix-update-script,
}:
let
  version = "0.8.1";
in
rustPlatform.buildRustPackage {
  pname = "manga-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "josueBarretogit";
    repo = "manga-tui";
    rev = "v${version}";
    hash = "sha256-CAmXTAUlwdc4iGzXonoYPd1okqgA4hWgR9bnsPsuDus=";
  };

  cargoHash = "sha256-viiL1LcBbWuKA+jgkAPc9gpI7wQu4UXfO5DSPm26ido=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    (lib.getDev openssl)
  ];

  checkInputs = [
    perl
    cacert
  ];

  meta = {
    description = "Terminal-based manga reader and downloader with image support";
    homepage = "https://github.com/josueBarretogit/manga-tui";
    changelog = "https://github.com/josueBarretogit/manga-tui/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      isabelroses
      youwen5
    ];
    mainProgram = "manga-tui";
  };

  passthru.updateScript = nix-update-script { };
}
