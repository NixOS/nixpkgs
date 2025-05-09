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

  __darwinAllowLocalNetworking = true;

  # On Darwin, sendme invokes CoreFoundation APIs that read ICU data from the
  # system. Ensure these paths are accessible in the sandbox to avoid segfaults
  # during checkPhase.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
  '';

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
