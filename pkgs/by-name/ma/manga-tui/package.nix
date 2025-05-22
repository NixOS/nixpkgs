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
  version = "0.7.0";
in
rustPlatform.buildRustPackage {
  pname = "manga-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "josueBarretogit";
    repo = "manga-tui";
    rev = "v${version}";
    hash = "sha256-1WFg2hG3UnOO9+HpUcdPkZNhsNYa2QG1PhzLZ4bQiQM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1nERwIZCR/afgfGdronpy145GnDkbsB7YjF6XyDcfEY=";

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
