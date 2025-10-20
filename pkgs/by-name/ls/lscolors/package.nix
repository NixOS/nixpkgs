{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.21.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-75RE72Vy4HRRjwa7qOybnUAzxxhBUKSlKfrLrm6Ish8=";
  };

  cargoHash = "sha256-a8G9snl6TrH90HvlfhDY/U8BuSoD7Fqn7BJSsRvEQ18=";

  buildFeatures = [ "nu-ansi-term" ];

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    changelog = "https://github.com/sharkdp/lscolors/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "lscolors";
  };
}
