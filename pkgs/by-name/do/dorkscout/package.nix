{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dorkscout";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "R4yGM";
    repo = pname;
    rev = version;
    hash = "sha256-v0OgEfl6L92ux+2GbSPHEgkmA/ZobQHB66O2LlEhVUA=";
  };

  vendorHash = "sha256-8Nrg90p/5hQBpuyh2NBE4KKxT4BM9jhWIZ6hXBpMdhc=";

  meta = with lib; {
    description = "Tool to automate the work with Google dorks";
    mainProgram = "dorkscout";
    homepage = "https://github.com/R4yGM/dorkscout";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
