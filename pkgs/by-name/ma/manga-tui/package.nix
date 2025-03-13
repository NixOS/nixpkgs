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
  version = "0.6.0";
in
rustPlatform.buildRustPackage {
  pname = "manga-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "josueBarretogit";
    repo = "manga-tui";
    rev = "v${version}";
    hash = "sha256-L5KZaBJDG0z6NUGPJfbOkKCp1xQEzqfJ9GREx189VqU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gmG/gDozYizwjcm3SGs2m8oLiuWp6oxJPOB3FlHfW+4=";

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
