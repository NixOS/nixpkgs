{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wnQ2NO+s6HumdxpO/qS/UeVdHgk9MvE6jpiSiBO0EIg=";
  };

  cargoHash = "sha256-5H/AQBPNSE5J+NQsSFn0z9dfG0ssxungpFJR220scgY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "Tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "sendme";
  };
}
