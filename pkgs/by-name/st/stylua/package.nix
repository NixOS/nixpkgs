{ lib
, rustPlatform
, fetchFromGitHub
  # lua54 implies lua52/lua53
, features ? [ "lua54" "luajit" "luau" ]
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/gCg1mJ4BDmgZ+jdWvns9CkhymWP3jdTqS7Z4n4zsO8=";
  };

  cargoHash = "sha256-A1J1n/KsnZyB9pZFGcMojNU9FFGxk8p6TxlRNW6EwCs=";

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
