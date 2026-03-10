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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = "stylua";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-MQUhVuwYaRpbx4iGRaQ8D1YXW7tsviEPiI2XaEjsvBg=";
  };

  cargoHash = "sha256-H/mxenzzyb+P1mrXNA5vRxmvNTtimWE6WYJeUB1Y8dQ=";

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
