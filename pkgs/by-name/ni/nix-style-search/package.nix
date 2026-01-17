{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "nix-style-search";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "snowflake-hd";
    repo = "nix-style-search";
    rev = "v${version}";
    hash = "sha256-GY1u1hdTQHiKdlbiW8OG2/Ks6Gw1DUy9jkDXmkqcPns=";
  };

  vendorHash = "sha256-NICwZgVyJ9q9Eg0b7vU0QJSkyAaK+BW0fPFGZXtDkbk=";

  subPackages = [ "cmd/nix-style-search" ];
  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "TUI for searching nixpkgs with style";
    mainProgram = "nix-style-search";
    homepage = "https://github.com/snowflake-hd/nix-style-search";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ snowflake-hd ];
  };
}
