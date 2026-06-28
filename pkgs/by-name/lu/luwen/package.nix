{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luwen";
  version = "0.8.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "luwen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lY7cZ+8C0UEGGYxufl4Vi8g0L4AJFXaGqn7XE2ivTcQ=";
  };

  nativeBuildInputs = [
    protobuf
  ];

  cargoHash = "sha256-QBGXbRiBk4WIQFopq1OccmUHgx5GzR/PKhMH4Ie+fyg=";

  meta = {
    description = "Tenstorrent system interface tools";
    homepage = "https://github.com/tenstorrent/luwen";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; asl20;
  };
})
