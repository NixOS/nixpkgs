{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "firezone-headless-client";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "firezone";
    repo = "firezone";
    tag = "headless-client-${version}";
    hash = "sha256-t7sq8Lv/Dh8mH/qvJP+eZ2VE7bipyh5CPuD821m2QKI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7YsA/siK+HOpXrhnW/0Fzws1UvQZCErnFF4loxR8/Z4=";
  sourceRoot = "${src.name}/rust";
  buildAndTestSubdir = "headless-client";

  # Required to remove profiling arguments which conflict with this builder
  postPatch = ''
    rm .cargo/config.toml
  '';

  # Required to run tests
  preCheck = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "CLI client for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ oddlama ];
    mainProgram = "firezone-headless-client";
  };
}
