{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  zig,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "messense";
    repo = "cargo-zigbuild";
    rev = "v${version}";
    hash = "sha256-xJiYtVrvWEBsyTbcHKsbnTpbcTryX+ZP/OjD7GP6gQU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-oByCrAUkDq+UxoAiKjKX86ETHW3yIs8oYVCgwgr8ngA=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-zigbuild \
      --prefix PATH : ${zig}/bin
  '';

  meta = {
    description = "Tool to compile Cargo projects with zig as the linker";
    mainProgram = "cargo-zigbuild";
    homepage = "https://github.com/messense/cargo-zigbuild";
    changelog = "https://github.com/messense/cargo-zigbuild/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
