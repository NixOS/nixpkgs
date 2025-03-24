{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "coldsnap";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "coldsnap";
    rev = "v${version}";
    hash = "sha256-NYMcCLFhX7eD6GXMP9NZDXDnXDDVbcvVwhUAqmwX+ig=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-wUpLYPBACinRO9j+ZrbmJohuN27BPB6ZYu8K14XJmGw=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "Command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
    mainProgram = "coldsnap";
  };
}
