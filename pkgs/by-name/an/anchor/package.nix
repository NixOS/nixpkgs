{
  lib,
  perl,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "coral-xyz";
    repo = "anchor";
    tag = "v${version}";
    hash = "sha256-oyCe8STDciRtdhOWgJrT+k50HhUWL2LSG8m4Ewnu2dc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  cargoHash = "sha256-XrVvhJ1lFLBA+DwWgTV34jufrcjszpbCgXpF+TUoEvo=";

  checkFlags = [
    # the following test cases try to access network, skip them
    "--skip=tests::test_check_and_get_full_commit_when_full_commit"
    "--skip=tests::test_check_and_get_full_commit_when_partial_commit"
    "--skip=tests::test_get_anchor_version_from_commit"
  ];

  meta = {
    description = "Solana Sealevel Framework";
    homepage = "https://github.com/coral-xyz/anchor";
    changelog = "https://github.com/coral-xyz/anchor/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Denommus ];
    mainProgram = "anchor";
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
}
