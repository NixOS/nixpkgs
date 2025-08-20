{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  libiconv,
  stdenv,
  libxcb,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "sss_code";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "SergioRibera";
    repo = "sss";
    rev = "sss_code/v${version}";
    hash = "sha256-AmJFAwHfG4R2iRz9zNeZsVFLptVy499ozQ7jgwnevOo=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-qeDZgrGPSz+wXolZeVb2FFHjLzl1+vjzMN/3NCgaf/s=";

  cargoBuildFlags = [
    "-p"
    "sss_code"
  ];

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.buildPlatform.isDarwin [ libiconv ];

  buildInputs = [
    fontconfig
    libxcb
  ];

  doCheck = false;

  meta = with lib; {
    description = "Libraries and tools for building screenshots in a high-performance image format";
    mainProgram = "sss_code";
    homepage = "https://github.com/SergioRibera/sss";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ krovuxdev ];
  };
}
