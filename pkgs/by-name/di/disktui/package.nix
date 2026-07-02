{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "disktui";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "Maciejonos";
    repo = "disktui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C0skZF7fP7Qx5o+q9bUitgnBB9tBh1J4JdGyn8oQ/Rc=";
  };
  cargoHash = "sha256-/4H4GSER/HBFElu6aNeyHkH1kqBd9DhoTXRkOxPrNSU=";

  meta = {
    description = "TUI for disk management on Linux";
    homepage = "https://github.com/Maciejonos/disktui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Inarizxc ];
    platforms = lib.platforms.linux;
    mainProgram = "disktui";
  };
})
