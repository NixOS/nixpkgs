{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.19.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-9xYWjpeXg646JEW7faRLE1Au6LRVU6QQ7zfAwmYffT0=";
  };

  cargoHash = "sha256-gtcznStbuYWcBPKZ/hdH15cwRQL0+Q0fZHe+YW5Rek0=";

  buildFeatures = [ "nu-ansi-term" ];

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    changelog = "https://github.com/sharkdp/lscolors/releases/tag/v${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "lscolors";
  };
}
