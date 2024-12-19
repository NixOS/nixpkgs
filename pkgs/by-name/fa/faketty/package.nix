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

  cargoHash = "sha256-LeTZkGhr1yTPG6OoukRB2+pcEAZKtjd9b60MLBi0Xl8=";

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
