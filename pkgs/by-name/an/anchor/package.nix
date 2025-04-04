{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "coral-xyz";
    repo = "anchor";
    rev = "v${version}";
    hash = "sha256-rwf2PWHoUl8Rkmktb2u7veRrIcLT3syi7M2OZxdxjG4=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ack2/WFrycfYHYVnZt0Q94WJdQrvLU/VZYm1KeqOjIQ=";

  checkFlags = [
    # the following test cases try to access network, skip them
    "--skip=tests::test_check_and_get_full_commit_when_full_commit"
    "--skip=tests::test_check_and_get_full_commit_when_partial_commit"
    "--skip=tests::test_get_anchor_version_from_commit"
  ];

  meta = with lib; {
    description = "Solana Sealevel Framework";
    homepage = "https://github.com/coral-xyz/anchor";
    changelog = "https://github.com/coral-xyz/anchor/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ Denommus ];
    mainProgram = "anchor";
  };
}
