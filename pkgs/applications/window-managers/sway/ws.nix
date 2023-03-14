{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayws";
  version = "unstable-2022-03-10";

  src = fetchFromGitLab {
    owner = "w0lff";
    repo = pname;
    rev = "514f3c664439cf2c11bb9096c7e1d3b8c0b898a2";
    sha256 = "sha256-vUnbn79v08riYLMBI8BxeBPpe/pHOWlraG7QAaohw3s=";
  };

  cargoSha256 = "sha256-PvKpcTewajvbzUHPssBahWVcAQB3V/aMmOJ/wA0Nrv4=";

  # swayws does not have any tests
  doCheck = false;

  meta = with lib; {
    description = "A sway workspace tool which allows easy moving of workspaces to and from outputs";
    homepage = "https://gitlab.com/w0lff/swayws";
    license = licenses.mit;
    maintainers = [ maintainers.atila ];
  };
}
