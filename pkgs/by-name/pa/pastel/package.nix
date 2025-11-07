{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "pastel";
    rev = "v${version}";
    sha256 = "sha256-kr2aLRd143ksVx42ZDO/NILydObinn3AwPCniXVVmY0=";
  };

  cargoHash = "sha256-u+1KDcC2KGqvmOk6k7hOHE16TMvDg92eMOdNMQQszug=";

  meta = {
    description = "Command-line tool to generate, analyze, convert and manipulate colors";
    homepage = "https://github.com/sharkdp/pastel";
    changelog = "https://github.com/sharkdp/pastel/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    mainProgram = "pastel";
  };
}
