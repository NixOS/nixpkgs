{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OBsVy1pCvybTp5IvqjBC20ofPxx/4thJELKhkb1FRHk=";
  };

  cargoHash = "sha256-sS0BCA4K+U0AfScY3v8AnKJxb5w8yFAFjbBr+nSFRN8=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "Tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "sendme";
  };
}
