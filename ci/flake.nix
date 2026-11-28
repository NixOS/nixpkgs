{
  description = "Nixpkgs CI locked inputs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    "nixpkgs-26_05-darwin".url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
  };

  nixConfig.commit-lock-file-summary = "ci/flake: update inputs";

  # This flake is only used for its inputs
  outputs = inputs: { };
}
