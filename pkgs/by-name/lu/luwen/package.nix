{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luwen";
  version = "0.7.14";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "luwen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KhkABISkR37MjEwgroVtywYNCxgfwXyM5LG2CIJhu3M=";
  };

  postUnpack = ''
    cp ${./Cargo.lock} $sourceRoot/Cargo.lock
  '';

  nativeBuildInputs = [
    protobuf
  ];

  # Vendor a lockfile until upstream manages to consistently have checksums in their's.
  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    description = "Tenstorrent system interface tools";
    homepage = "https://github.com/tenstorrent/luwen";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
})
