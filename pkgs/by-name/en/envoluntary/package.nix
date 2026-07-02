{
  lib,
  rustPlatform,
  fetchFromGitHub,
  bash,
}:

rustPlatform.buildRustPackage rec {
  pname = "envoluntary";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "dfrankland";
    repo = "envoluntary";
    tag = "envoluntary-v${version}";
    hash = "sha256-ccMXrR7PnV3aCehJtsJyXx5ZiCz/KrHkKDLQSV3sMYU=";
  };

  cargoHash = "sha256-AXWOU8UduQZxZWcTaOyxilbdz4BMnZlrJEFTUakFa4w=";

  preCheck = ''
    export NIX_BIN_BASH="${bash}/bin/bash"
  '';

  meta = {
    description = "Automatic Nix development environments for your shell";
    longDescription = ''
      Envoluntary seamlessly loads and unloads Nix development environments based on directory
      patterns, eliminating the need for per-project .envrc / flake.nix files while giving you
      centralized control over your development tooling.
    '';
    homepage = "https://github.com/dfrankland/envoluntary";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ blemouzy ];
    mainProgram = "envoluntary";
  };
}
