{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cocom";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "LamdaLamdaLamda";
    repo = "cocom";
    rev = "v${version}";
    sha256 = "0sl4ivn95sr5pgw2z877gmhyfc4mk9xr457i5g2i4wqnf2jmy14j";
  };

  cargoHash = "sha256-kfseD0dYNC1IFAamLJee7LozGppE2mZgBMCUHJC0dP4=";

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "NTP client";
    homepage = "https://github.com/LamdaLamdaLamda/cocom";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cocom";
  };
}
