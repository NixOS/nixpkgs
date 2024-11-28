{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  openssl,
  mpv,
}:
rustPlatform.buildRustPackage rec {
  pname = "radio-cli";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "margual56";
    repo = "radio-cli";
    rev = "v${version}";
    hash = "sha256-XN0IzU7+V0zUUXfOygWrZXQX09IEpVo2Rhwfv+Lny/E=";
  };

  cargoHash = "sha256-XCzDNUZpyfu4gJr1lUx1/VbLkEv3OnJvYku0eEJbK5s=";

  buildInputs = [ openssl ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  postInstall = ''
    wrapProgram "$out/bin/radio-cli" \
      --suffix PATH : ${lib.makeBinPath [ mpv ]}
  '';

  meta = {
    description = "Simple radio CLI written in rust";
    homepage = "https://github.com/margual56/radio-cli";
    changelog = "https://github.com/margual56/radio-cli/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "radio-cli";
    platforms = lib.platforms.linux;
  };
}
