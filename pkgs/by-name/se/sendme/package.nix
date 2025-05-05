{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "sendme";
    rev = "v${version}";
    hash = "sha256-OmP2FLvBupeJeGhMMBgcTpMSgQZ5JWzXBVeFZt7EU4Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8Ry3rpGTNcvMIA3Q10Cb3uJHOBQin9AhlLNRekaKw/0=";

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
