{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.18";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-b6rHyg1rHMihmJ1okH11uDvOsqNydfK/c1cAgP6Tvx0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-POxCsGcM2P/fP/yEHuNFDz90H2qbKHgnuMowZS1hn7A=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = with lib; {
    description = "Wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    changelog = "https://github.com/dtolnay/faketty/releases/tag/${version}";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "faketty";
  };
}
