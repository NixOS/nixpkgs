{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Misterio77";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rDy859jg+F8XC4sJogIgdn1FoT8cf7S+KORt+7kboAc=";
  };

  cargoSha256 = "sha256-cAXiAPhHdxdd8pFQ0Gq7eHO2p/Dam53gDbE583UYY/k=";

  meta = with lib; {
    description = "An easy to use base16 scheme manager/builder that integrates with any workflow";
    homepage = "https://github.com/Misterio77/flavours";
    changelog = "https://github.com/Misterio77/flavours/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
