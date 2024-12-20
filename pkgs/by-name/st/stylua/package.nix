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
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sZrymo1RRfDLz8fPa7FnbutSpOCFoyQPoFVjA6BH5qQ=";
  };

  cargoHash = "sha256-fgj6C9Mq8Xyg1nuMZ5GtT4GkK+kUFtGfP8V8B8sLEgY=";

  # remove cargo config so it can find the linker on aarch64-unknown-linux-gnu
  postPatch = ''
    rm .cargo/config.toml
  '';

  buildFeatures = features;

  meta = with lib; {
    description = "Opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog = "https://github.com/johnnymorganz/stylua/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "stylua";
  };
}
