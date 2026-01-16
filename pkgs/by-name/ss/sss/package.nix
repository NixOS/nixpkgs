{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  libxcb,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "sss";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "SergioRibera";
    repo = "sss";
    rev = "sss_cli/v${version}";
    hash = "sha256-ZcCfPnWE1hEPeVdlh4l4XsV4VAl10+xSsm5/9NPjXpc=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-twnJesIgjMMo/zuI0p+SwhSjBwUWSeADxyewKglFej0=";

  cargoBuildFlags = [
    "-p"
    "sss_cli"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    freetype
    libxcb
  ];

  doCheck = false;

  meta = with lib; {
    description = "CLI and library to take amazing screenshot of screen";
    mainProgram = "sss";
    homepage = "https://github.com/SergioRibera/sss";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ krovuxdev ];
  };
}
