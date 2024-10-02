{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nDYsNaR3NQ6ut6gtHwEoiwhj4B4Bac5+NOOq3H2NCYY=";
  };

  cargoHash = "sha256-U2/GUpWtpTX+RCBojh3N6DsWB0gjFkH1mGA+AS+fH+o=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
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
