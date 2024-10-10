{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  # latest release version, without "v" prefix and "+commit" build metadata
  # semver information:
  # https://github.com/peterldowns/nix-search-cli/releases/tag/v0.2%2Bcommit.7d6b4c5
  version = "0.2.0";
  commit = "7d6b4c5";
  srcHash = "sha256-0Zms/QVCUKxILLLJYsaodSW64DJrVr/yB13SnNL8+Wg=";
  vendorHash = "sha256-RZuB0aRiMSccPhX30cGKBBEMCSvmC6r53dWaqDYbmyA=";
in buildGoModule {
  pname = "nix-search-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "peterldowns";
    repo = "nix-search-cli";
    rev = "7d6b4c501ee448dc2e5c123aa4c6d9db44a6dd12";
    hash = srcHash;
  };
  inherit vendorHash;

  # These should match the options defined in the upstream repo:
  # https://github.com/peterldowns/nix-search-cli/blob/main/flake.nix
  ldflags = [
    "-X main.Version=${version}"
    "-X main.Commit=${commit}"
  ];
  GOWORK = "off";
  modRoot = ".";
  doCheck = false;
  subPackages = [
    "cmd/nix-search"
  ];

  meta = with lib; {
    description = "CLI for searching packages on search.nixos.org";
    homepage = "https://github.com/peterldowns/nix-search-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover peterldowns ];
    platforms = platforms.all;
    mainProgram = "nix-search";
  };
}
