{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
  # lua54 implies lua52/lua53
  features ? [
    "lua54"
    "luajit"
    "luau"
  ],
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stylua";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = "stylua";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-C0X7IdYqs/hhSX96XWVyk7rfQNd9DjYxYgHL34cI+3g=";
  };

  cargoHash = "sha256-m31oocBkx4i2KxM0YC1omVWtypFi7iEoDVlXgT93iSI=";

  # remove cargo config so it can find the linker on aarch64-unknown-linux-gnu
  postPatch = ''
    rm .cargo/config.toml
  '';

  buildFeatures = features;

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog = "https://github.com/johnnymorganz/stylua/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      LunNova
      figsoda
    ];
    mainProgram = "stylua";
  };
})
