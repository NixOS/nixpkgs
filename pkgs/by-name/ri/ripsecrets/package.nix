{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ripsecrets";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "sirwart";
    repo = "ripsecrets";
    rev = "v${version}";
    hash = "sha256-lmahS/0W5075vdPfj4QnX7ZvrxHi986/92PRrplFblg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AO0EL2JNwrqwUa7QLNB8/fjLP3HzBqidHR21YSmrMqg=";

  meta = with lib; {
    description = "Command-line tool to prevent committing secret keys into your source code";
    homepage = "https://github.com/sirwart/ripsecrets";
    changelog = "https://github.com/sirwart/ripsecrets/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ripsecrets";
  };
}
