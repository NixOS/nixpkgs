{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "leptosfmt";
  version = "0.1.33";

  src = fetchFromGitHub {
    owner = "bram209";
    repo = "leptosfmt";
    tag = version;
    hash = "sha256-+trLQFU8oP45xHQ3DsEESQzQX2WpvQcfpgGC9o5ITcY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-m9426zuxp9GfbYoljW49BVgetLTqqcqGHCb7I+Yw+bc=";

  meta = with lib; {
    description = "Formatter for the leptos view! macro";
    mainProgram = "leptosfmt";
    homepage = "https://github.com/bram209/leptosfmt";
    changelog = "https://github.com/bram209/leptosfmt/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
