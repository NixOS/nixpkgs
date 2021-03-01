{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "Misterio77";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lvbq026ap02f22mv45s904a0f81dr2f07j6bq0wnwl5wd5w0wpj";
  };

  cargoSha256 = "0wgi65k180mq1q6j4nma0wpfdvl67im5v5gmhzv1ap6xg3bicdg1";

  meta = with lib; {
    description = "An easy to use base16 scheme manager/builder that integrates with any workflow";
    homepage = "https://github.com/Misterio77/flavours";
    changelog = "https://github.com/Misterio77/flavours/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
