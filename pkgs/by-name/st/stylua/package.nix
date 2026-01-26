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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = "stylua";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-wpFp6K5O1Vb/yHq+Lm0235nbeOdOgBK0NrlVAthz12A=";
  };

  cargoHash = "sha256-+llL9WoKnrXJjlaPNqdN4jGPjSHz2EuI2V44fghF5aM=";

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
    maintainers = [ lib.maintainers.LunNova ];
    mainProgram = "stylua";
  };
})
