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
  version = "0-unstable-2024-04-13";

  src = fetchFromGitHub {
    owner = "vldmrkl";
    repo = "airdrop-cli";
    rev = "dcdd570c3af3aae509ba7ad9fb26782b427f3a1a";
    hash = "sha256-7gKKeedRayf27XrOhntu41AMXgxc7fqJRE8Jhbihh3o=";
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
