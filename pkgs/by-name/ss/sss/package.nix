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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mouse_position-0.1.3" = "sha256-aYgWaozAECw+RzD2cOT7OxYzKJd2MlLsXkqW27BjSwI=";
    };
  };

  # Removed 'sss_code' command due to version differences and to separate commands.
  postInstall = ''
    rm -f $out/bin/sss_code
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fontconfig freetype libxcb ];

  meta = with lib; {
    description = "A CLI/Lib to take amazing screenshot of screen";
    mainProgram = "sss";
    homepage = "https://github.com/SergioRibera/sss";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ krovuxdev ];
  };
}
