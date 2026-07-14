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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "concord-tui";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "concord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/79Hq54qXWXLopPda6xiZ6892UpVoKXQad84QOXCTDM=";
  };

  cargoHash = "sha256-Ihr4JM0hKEvJ9FMcQ5VPtemJjjPB5mXvAeDa4G0pGSo=";

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
