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
  version = "0.8.0";
in
rustPlatform.buildRustPackage {
  pname = "manga-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "josueBarretogit";
    repo = "manga-tui";
    rev = "v${version}";
    hash = "sha256-81P5LwL9njxA0qx4FvqgrHdqVgUXkZTTzAXLdRTftS4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dne0sJ0K/UVXGaj/vUM9O++ZS0hu69bdLnV8VAr3tbM=";

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
