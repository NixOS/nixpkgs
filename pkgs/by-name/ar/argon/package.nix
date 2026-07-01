{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  zstd,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "argon";
  version = "2.0.29";

  src = fetchFromGitHub {
    owner = "argon-rbx";
    repo = "argon";
    tag = finalAttrs.version;
    hash = "sha256-i2YWAXgrcS759+iNtSzjIHU1FmY22Xx6sy2q9ErGsnw=";
  };

  cargoHash = "sha256-wj+T1XBLVQsDNMT9d/0ybR+L7fDZj4Ijhqv0fH+f7HA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Full featured tool for Roblox development";
    homepage = "https://github.com/argon-rbx/argon";
    changelog = "https://github.com/argon-rbx/argon/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ StayBlue ];
    mainProgram = "argon";
  };
})
