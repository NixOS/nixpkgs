{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  systemd,
}:
rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.32.1";
  src = fetchFromGitHub {
    owner = "coral-xyz";
    repo = "anchor";
    tag = "v${version}";
    hash = "sha256-7YOPbMuhdssROoSG6wvwKaCFRF2ZgRLG7kwHZoY+gys=";
    fetchSubmodules = true;
  };
  cargoHash = "sha256-XrVvhJ1lFLBA+DwWgTV34jufrcjszpbCgXpF+TUoEvo=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    systemd
  ];
  OPENSSL_NO_VENDOR = "1";
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
  };
}
