{
  lib,
  rustPlatform,
  fetchFromGitLab,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-gg";
  version = "0.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.scd31.com";
    owner = "stephen";
    repo = "cargo-gg";
    tag = "v${version}";
    hash = "sha256-SnxMY8HDVIVp6zNGFiGZDJK0B76rktKhOw/Xtad96SA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TSvYUkRs0e7Bf6YwFcRYEc4QrHfZV6/dCZPki5a11B0=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cargo wrapper that calls you a good girl if your commands succeed (but only after they fail)";
    mainProgram = "cargo-gg";
    homepage = "https://gitlab.scd31.com/stephen/cargo-gg";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [ scd31 ];
  };
}
