{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luwen";
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "luwen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J0SvCBsDi3GMvnwqgqGMUDvrSO+baznDhsfuvF44Ens=";
  };

  nativeBuildInputs = [
    protobuf
  ];

  cargoHash = "sha256-vEuVxBGIJAyc8POy3EPTzTK5g5SE3QDZcnTnAb3b5k0=";

  meta = {
    description = "Tenstorrent system interface tools";
    homepage = "https://github.com/tenstorrent/luwen";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.asl20;
  };
})
