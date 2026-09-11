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
  version = "0.10.0";
in
rustPlatform.buildRustPackage {
  pname = "manga-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "josueBarretogit";
    repo = "manga-tui";
    rev = "v${version}";
    hash = "sha256-HD/27YFapOq32DE89Y6RNTBGHvpCbh/0fOhUECVe8sM=";
  };

  cargoHash = "sha256-JvN9vG4kxmGd3odR/RnUV0dK7I94EEMITePyr0cP4pg=";

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
