{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "spacer";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "samwho";
    repo = "spacer";
    rev = "v${version}";
    hash = "sha256-N6HNPuEYcbuqpHv8Qr43iRtRdtyBo4TP7YccIcbpIpc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/sUQy5dn83KLzBXZ2+QEMM6hOqE7T3tZ80Q3M510jjQ=";

  meta = with lib; {
    description = "CLI tool to insert spacers when command output stops";
    homepage = "https://github.com/samwho/spacer";
    changelog = "https://github.com/samwho/spacer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "spacer";
  };
}
