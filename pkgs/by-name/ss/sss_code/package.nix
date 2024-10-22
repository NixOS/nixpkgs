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
  pname = "sss_code";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "SergioRibera";
    repo = "sss";
    rev = "sss_code/v${version}";
    hash = "sha256-rVEFdbbLghjaFaut5Xi0oK3Q1kuo3tUANfhvjnb7+3A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mouse_position-0.1.3" = "sha256-aYgWaozAECw+RzD2cOT7OxYzKJd2MlLsXkqW27BjSwI=";
    };
  };

  # Removed 'sss' command due to version differences and to separate commands.
  postInstall = ''
    rm -f $out/bin/sss
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fontconfig freetype libxcb ];

  meta = with lib; {
    description = "A CLI/Lib to take amazing screenshot of code";
    mainProgram = "sss_code";
    homepage = "https://github.com/SergioRibera/sss";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ krovuxdev ];
  };
}
