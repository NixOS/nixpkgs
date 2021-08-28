{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Misterio77";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rDy859jg+F8XC4sJogIgdn1FoT8cf7S+KORt+7kboAc=";
  };

  buildInputs = [ ]
    ++ lib.optionals stdenv.isDarwin [ libiconv ];

  cargoSha256 = "sha256-I8ZH35L2CVLy6ypmdOPd8VEG/sQeGaHyT1HWNdwyZVo=";

  meta = with lib; {
    description = "An easy to use base16 scheme manager/builder that integrates with any workflow";
    homepage = "https://github.com/Misterio77/flavours";
    changelog = "https://github.com/Misterio77/flavours/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
