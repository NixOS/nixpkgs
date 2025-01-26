{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
  sqlite,
  stdenv,
  darwin,
  nix-update-script,
}:
let
  version = "0.5.0";
in
rustPlatform.buildRustPackage {
  pname = "manga-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "josueBarretogit";
    repo = "manga-tui";
    rev = "v${version}";
    hash = "sha256-kmJrr1Gi1z9v2gkFmvcCAtBST+AkofVJSxyvAFnUZKQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YtRNMjip/KSWQYQh6Ye14b56u+DcK8WKE1nFK2zSWtM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
      sqlite
      dbus
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );

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
