{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "coral-xyz";
    repo = "anchor";
    tag = "v${version}";
    hash = "sha256-pvD0v4y7DilqCrhT8iQnAj5kBxGQVqNvObJUBzFLqzA=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-fjhLA+utQdgR75wg+/N4VwASW6+YBHglRPj14sPHmGA=";

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
