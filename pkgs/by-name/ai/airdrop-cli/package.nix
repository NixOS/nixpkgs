{
  lib,
  fetchFromGitHub,
  swift,
  swiftPackages,
  swiftpm,
}:

# Doesn't build without using the same stdenv (and Clang) to build swift
swiftPackages.stdenv.mkDerivation {
  pname = "airdrop-cli";
  version = "0-unstable-2025-07-14";

  src = fetchFromGitHub {
    owner = "vldmrkl";
    repo = "airdrop-cli";
    rev = "8bb7d64c9f9ce1166405aa5b9a11f00dcc466ea0";
    hash = "sha256-aaczNVDJhkzeaSBXP+HmgHGZWVztggwv3OtTBAFCFvk=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Use Airdrop from the CLI on macOS written in Swift";
    homepage = "https://github.com/vldmrkl/airdrop-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Enzime ];
    mainProgram = "airdrop";
    platforms = lib.platforms.darwin;
  };
}
