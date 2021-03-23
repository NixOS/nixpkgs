{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "Misterio77";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nys1sh4qwda1ql6aq07bhyvhjp5zf0qm98kr4kf2fmr87ddc12q";
  };

  cargoSha256 = "0bmmxiv8bd09kgxmhmynslfscsx2aml1m1glvid3inaipylcq45h";

  meta = with lib; {
    description = "An easy to use base16 scheme manager/builder that integrates with any workflow";
    homepage = "https://github.com/Misterio77/flavours";
    changelog = "https://github.com/Misterio77/flavours/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
