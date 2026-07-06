{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  libarchive,
  openssl,
  pkg-config,
  bubblewrap,
  elfutils,
  nix,
  nixosTests,
  systemd,
  util-linux,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixseparatedebuginfod2";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nixseparatedebuginfod2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PG/TqfXTuricAcwCB+2dKlVgHXxhCVVRJaVJ5v0xd4o=";
  };

  cargoHash = "sha256-XDkW1tCSvmiTU0GN3L0oL0uhgWYQSlxRIV0xcwSlgkY=";

  buildInputs = [
    libarchive
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    systemd
  ];

  nativeBuildInputs = [ pkg-config ];

  doCheck = stdenv.hostPlatform.isLinux;
  nativeCheckInputs = [
    bubblewrap
    elfutils
    nix
    util-linux
    cacert
  ];

  # disable systemd feature on non linux
  cargoBuildFlags = lib.optionals (!stdenv.hostPlatform.isLinux) [
    "--no-default-features"
  ];

  env.OPENSSL_NO_VENDOR = "1";

  passthru.tests = { inherit (nixosTests) nixseparatedebuginfod2; };

  meta = {
    description = "Downloads and provides debug symbols and source code for nix derivations to gdb and other debuginfod-capable debuggers as needed";
    homepage = "https://github.com/symphorien/nixseparatedebuginfod2";
    changelog = "https://https://github.com/symphorien/nixseparatedebuginfod2/blob/v${finalAttrs.version}/CHANGELOG.md/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      symphorien
      feyorsh
    ];
    platforms = lib.platforms.unix;
    mainProgram = "nixseparatedebuginfod2";
  };
})
