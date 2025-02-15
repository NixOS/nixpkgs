{
  lib,
  fetchgit,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "spl";
  version = "0.4.2";

  passthru.updateScript = nix-update-script { };

  src = fetchgit {
    url = "https://git.tudbut.de/tudbut/spl";
    rev = "v${version}";
    hash = "sha256-cU6qSh4HM3os/A1w0+5TSZLkS2Y/C864qvmixkxPAh8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ra3pNw3NJ9hSSxb1O7piMD+1cPeofTAYbdM9WRlwYKo=";

  meta = {
    description = "Simple, concise, concatenative scripting language";
    homepage = "https://git.tudbut.de/tudbut/spl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "spl";
  };
}
