{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  zig,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sUoEKLaUBxKKtCwgw/CcLrVRA4OMhto7d0PR+TMU5xk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-jvSOYWydnCFgJx1LTzQ1kHEVpzsdPLo19NVMBaLJEeQ=";

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
