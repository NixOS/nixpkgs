{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "sad";
  version = "0.4.32";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "sad";
    tag = "v${version}";
    hash = "sha256-c5TYIVUrfKrVuyolVe7+EhiM/SOFNahz8X6F8WrKEa0=";
  };

  cargoHash = "sha256-hS66/bPRUpwmW/wSpZCq4kVKFkIhttsozIr3SCyZqQI=";

  nativeBuildInputs = [ python3 ];

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    changelog = "https://github.com/ms-jpq/sad/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      ryan4yin
    ];
    mainProgram = "sad";
  };
}
