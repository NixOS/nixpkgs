{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luwen";
  version = "0.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "luwen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pc/7G9YxBTg2uYn47ONxI7zsfdK3Ex4zndLASRtDQyk=";
  };

  nativeBuildInputs = [
    protobuf
  ];

  cargoHash = "sha256-2ibAZnfv++eyCB57F0uD7XFJ3MP9SnAApOn6uelo3Po=";

  meta = {
    description = "Tenstorrent system interface tools";
    homepage = "https://github.com/tenstorrent/luwen";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.asl20;
  };
})
