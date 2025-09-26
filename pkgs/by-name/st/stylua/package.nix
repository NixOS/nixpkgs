{
  lib,
  rustPlatform,
  fetchFromGitHub,
  # lua54 implies lua52/lua53
  features ? [
    "lua54"
    "luajit"
    "luau"
  ],
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = "stylua";
    rev = "v${version}";
    sha256 = "sha256-PBe3X4YUFUV2xQdYYOdPNgJCnCOzrzogP/2sECef4ck=";
  };

  cargoHash = "sha256-C9g6kA+xc0nixiPAijc5MIF9xHbbeXBHtmdM4QRdf/Q=";

  # remove cargo config so it can find the linker on aarch64-unknown-linux-gnu
  postPatch = ''
    rm .cargo/config.toml
  '';

  buildFeatures = features;

  meta = {
    description = "Opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog = "https://github.com/johnnymorganz/stylua/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "stylua";
  };
}
