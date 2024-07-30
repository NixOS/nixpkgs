{ lib
, fetchFromGitHub
, rustPlatform
, makeBinaryWrapper
, fuzzel
, additionalPrograms ? [ ]
}:

rustPlatform.buildRustPackage rec {
  pname = "raffi";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    rev = "v${version}";
    hash = "sha256-i4PM82vGb9Z2pwW006114/h9crokVLUpLxNjr7tgAU8=";
  };

  cargoHash = "sha256-DS56H2XjEgdXC9TKLjwyfLpFHB9dUThhr8pNFEJuAZE=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postFixup = ''
    wrapProgram $out/bin/raffi \
      --prefix PATH : ${lib.makeBinPath ([ fuzzel ] ++ additionalPrograms)}
  '';

  meta = {
    description = "Fuzzel launcher based on yaml configuration";
    homepage = "https://github.com/chmouel/raffi";
    changelog = "https://github.com/chmouel/raffi/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ aos ];
    mainProgram = "raffi";
    platforms = lib.platforms.linux;
  };
}
