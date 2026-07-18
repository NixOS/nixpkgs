{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  cmake,
  opus,
  lib,
  stdenv,
  # TODO: Clean up on `staging`
  lld,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "concord-tui";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3c5jxpJrBr6vYnbcJIYD06d932Da94hXUZA5FLa3kkU=";
  };

  cargoHash = "sha256-6iAyKsS+FoNCKkMvbL70vKSPoAaKQtUDiAQGaEMuxWk=";

  buildInputs = [
    opus
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];
  nativeBuildInputs = [
    pkg-config
    cmake
  ]
  # TODO: Clean up on `staging`
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    lld
  ];

  __darwinAllowLocalNetworking = true;

  __structuredAttrs = true;

  # TODO: Clean up on `staging`
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_LINK = "-fuse-ld=${lib.getExe' lld "ld64.lld"}";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-rich TUI client for Discord, written in Rust";
    homepage = "https://github.com/chojs23/concord";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      Simon-Weij
      neo
      Br1ght0ne
    ];
    mainProgram = "concord";
  };
})
